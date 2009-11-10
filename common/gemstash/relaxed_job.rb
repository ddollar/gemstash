require 'relaxed_job'
require 'gemstash'

module Gemstash::RelaxedJob

  def worker
    @worker ||= RelaxedJob::Worker.new(ENV['RELAXED_JOB_URL'])
  end

  def queue
    @queue ||= RelaxedJob::Queue.new(ENV['RELAXED_JOB_URL'])
  end

end
