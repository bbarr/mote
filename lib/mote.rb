require "bson"
require "mongo"

$LOAD_PATH << "./lib"
require "mote/document"
require "mote/cursor"
require "mote/extensions"

Mote.autoload :Callbacks, "mote/callbacks"
Mote.autoload :Keys, "mote/keys"
Mote.autoload :PkFactory, "mote/pk_factory"

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
