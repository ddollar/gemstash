require 'right_aws'
require 'gemstash'

module Gemstash::S3
  
  def s3
    @s3 ||= begin
      connection = RightAws::S3.new(ENV['S3_ACCESS'], ENV['S3_SECRET'])
      connection.bucket(ENV['S3_BUCKET'], true)
    end
  end

end