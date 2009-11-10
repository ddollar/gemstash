require 'rubygems/specification'
require 'sinatra'
require 'uuid'

require 'gemstash'
require 'gemstash/couchdb'
require 'gemstash/relaxed_job'
require 'gemstash/s3'

require 'gemstash/job'

class Gemstash::Site < Sinatra::Base

  include Gemstash::CouchDB
  include Gemstash::RelaxedJob
  include Gemstash::S3

  set :app_file, __FILE__
  set :display_configs, 3
  set :static, true

  if ENV['RACK_ENV'] == 'development'
    set :show_exceptions, true
  end

  get '/' do
    haml :index
  end

  get '/gems/:name' do |name|
    spec_hash = couchdb.first('gems/all', :key => name)
    spec = Gem::Specification.new
    spec_hash.each do |key, value|
      method = "#{key}="
      spec.send(method, value) if spec.respond_to?(method)
    end
    raise spec.inspect
  end

  post '/gems' do
    filename = "#{UUID.generate}.gem"
    couchdb.save_doc :class => 'job', :type => 'upload', :filename => filename
    s3.put "temp/#{filename}", request.body.read
    queue.enqueue Gemstash::Job::ProcessUpload.new(filename)
  end

end
