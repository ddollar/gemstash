require 'sinatra'
require 'gemstash'

class Gemstash::Site < Sinatra::Base

  set :app_file, __FILE__
  set :display_configs, 3
  set :static, true

  if ENV['RACK_ENV'] == 'development'
    set :show_exceptions, true
  end

  get '/' do
    haml :index
  end

  post '/gems' do
    raise request.env.keys.inspect
    raise request.env['HTTP_AUTHORIZATION'].inspect
    raise request.body.read.inspect
  end

end
