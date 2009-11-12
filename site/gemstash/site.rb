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

  # get '/' do
  #   haml :index
  # end

  get '/gems' do
    haml :gems
  end

  get '/gems/:name.gemspec' do |name|
    content_type 'text/plain'
    gem_specification(name).to_yaml
  end

  get '/gems/:name.json' do |name|
    content_type 'text/plain'
    gem_hash(name).to_json
  end

  post '/gems' do
    filename = "#{UUID.generate}.gem"
    s3.put "temp/#{filename}", request.body.read
    queue.enqueue Gemstash::Job::ProcessUpload.new(filename)
  end

private ######################################################################

  def gems
    couchdb.view('gems/all')['rows'].map { |row| row['value']['name'] }
  end

  def gem_hash(name)
    id = couchdb.first('gems/all', :key => name)['value']['_id']
    couchdb.get(id)
  end

  def gem_specification(name)
    gem  = gem_hash(name)
    spec = Gem::Specification.new

    gem.each do |key, value|
      method = "#{key}="
      spec.send(method, value) if spec.respond_to?(method)
    end

    gem['dependencies'].each do |dependency|
      spec.send(:add_dependency_with_type,
        dependency['name'],
        dependency['type'].to_sym,
        dependency['requirements']
      )
    end

    spec
  end

end
