require 'couchrest'
require 'gemstash'

module Gemstash::CouchDB

  def couchdb
    @couchdb ||= CouchRest.database!(ENV['COUCHDB_URL'])
  end

end
