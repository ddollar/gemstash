require 'rubygems'
require 'rack_environment'
require 'libdir'

libdir  'site'
require 'gemstash/site'

use RackEnvironment
run Gemstash::Site.new
