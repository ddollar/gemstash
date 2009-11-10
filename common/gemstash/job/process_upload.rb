require 'gemstash/job'

class Gemstash::Job::ProcessUpload

  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def perform
  end

end
