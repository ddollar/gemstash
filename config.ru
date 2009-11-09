require 'rubygems'
require 'rack_environment'
require 'libdir'

libdir  'site'
require 'gemstash/site'

use RackEnvironment if ENV['RACK_ENV'] == 'development'
run Gemstash::Site.new
