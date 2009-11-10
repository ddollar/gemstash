require 'gemstash/couchdb'
require 'gemstash/job'
require 'gemstash/s3'

require 'rubygems/format'

class Gemstash::Job::ProcessUpload

  include Gemstash::CouchDB
  include Gemstash::S3

  attr_reader :filename

  def initialize(filename)
    @filename = filename
  end

  def perform
    gem_data = StringIO.new(s3.get("temp/#{filename}"))
    format = Gem::Format.from_io(gem_data)

    spec_hash = format.spec.class.attribute_names.inject({}) do |hash, attribute|
      hash.update(attribute => format.spec.send(attribute))
    end

    couchdb.save_doc(spec_hash.merge(:class => 'gem'))
  end

end
