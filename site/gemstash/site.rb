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

  get '/gems' do
    s3.keys.inspect
  end

  post '/gems' do
    filename = "#{UUID.generate}.gem"
    couchdb.save_doc :class => 'job', :type => 'upload', :filename => filename
    s3.put "temp/#{UUID.generate}.gem", request.body.read
    queue.enqueue Gemstash::Job::ProcessUpload.new(filename)
  end

end
