require "bson"
require "mongo"

$LOAD_PATH << "./lib"
require "mote/document"
require "mote/cursor"

Mote.autoload(:Callbacks, "mote/callbacks")

module Mote
  class << self
    def db
      @db
    end

    def db=(mongo_db)
      unless mongo_db.is_a? Mongo::DB
        raise ArgumentError, "Must supply a valid Mongo::DB object"
      end
      @db = mongo_db
    end
  end
end
