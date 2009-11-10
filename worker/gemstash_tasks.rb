require 'rack_environment/task'

require 'gemstash/relaxed_job'
require 'gemstash/job'

RackEnvironment::Task.new

namespace :jobs do

  include Gemstash::RelaxedJob

  desc 'Run the job queue'
  task :work => :rack_environment do
    worker.start
  end
  
end
