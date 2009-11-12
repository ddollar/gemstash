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

    spec_hash = gem_specification_to_hash(format.spec)

    couchdb.save_doc(spec_hash.merge(:class => 'gem'))
  end

private ######################################################################

  def gem_specification_to_hash(spec)
    spec_hash = spec.class.attribute_names.inject({}) do |hash, attribute|
      hash.update(attribute => spec.send(attribute))
    end

    spec_hash[:dependencies].map! do |dependency|
      {
        :name         => dependency.name,
        :type         => dependency.type,
        :requirements => dependency.requirement_list
      }
    end

    spec_hash[:created_at] = Time.now
    spec_hash[:updated_at] = Time.now

    spec_hash
  end

end
