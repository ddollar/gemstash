require 'rubygems'
require 'rack_environment'
require 'libdir'

vendor  'couchrest-0.34'

libdir  'common'
libdir  'site'
require 'gemstash/site'

use RackEnvironment if ENV['RACK_ENV'] == 'development'
run Gemstash::Site.new
