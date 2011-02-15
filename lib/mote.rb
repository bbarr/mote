require "bson"
require "mongo"

$LOAD_PATH << "./lib"
require "mote/document"
require "mote/cursor"
require "mote/extensions"

# Load in some particular active_support modules
require "active_support/core_ext/array/wrap"
require 'active_support/inflector'
require 'active_support/json'

Mote.autoload :Callbacks, "mote/callbacks"
Mote.autoload :Keys, "mote/keys"
Mote.autoload :PkFactory, "mote/pk_factory"
Mote.autoload :Timestamps, "mote/timestamps"
Mote.autoload :Search, "mote/search"

ActiveSupport.autoload :Concern, "active_support/concern"
ActiveSupport.autoload :Callbacks, "active_support/callbacks"

module Mote

  MOTE_MODULES = [:Keys, :Callbacks]

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
