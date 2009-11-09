require 'delayed_job'

namespace :jobs do

  desc 'Run the DelayedJob worker'
  task :work do
    Delayed::Worker.new.start
  end
  
end
