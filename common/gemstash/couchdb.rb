require 'couchrest'
require 'gemstash'

module Gemstash::CouchDB

  def couchdb
    @couchdb ||= begin
      database = CouchRest.database!(ENV['COUCHDB_URL'])
      database.update_designs File.join(File.dirname(__FILE__), '..', '..', 'designs')
      database
    end
  end

end
