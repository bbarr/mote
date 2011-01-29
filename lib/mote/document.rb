require 'active_support/inflector'

module Mote

  # Basic document class for representing documents in a
  # mongo db collection
  class Document

    class << self
      def db
        Mote.db
      end

      # Following the standard that a document is singular but a collection is plural
      #
      # @example Document
      #   Book #=> Books
      #
      # @return [String] Pluralized and lowercase collection name based off the model name
      def collection_name
        self.to_s.pluralize.downcase
      end

      # Return the raw MongoDB collection for the model from the Ruby Driver
      def collection
        @collection ||= self.db.collection(self.collection_name)
      end

      # Proxy a MongoDB Driver find call
      #
      # @see Mongo::Collection#find
      # @see https://github.com/banker/mongo-ruby-driver/blob/master/lib/mongo/collection.rb#L68-130
      def find(selector={}, options={})
        Mote::Cursor.new self, collection.find(selector, options)
      end

      # Proxy a call to the MongoDB driver to find_one and return a <Mote::Document>
      # for the result that is found if any
      #
      # @see Mongo::Collection#find_one
      # @see https://github.com/banker/mongo-ruby-driver/blob/master/lib/mongo/collection.rb#L132-154
      def find_one(selector={}, options={})
        return nil unless doc = self.collection.find_one(selector, options)
        self.new(doc, false)
      end

      def all
        find
      end

    end

    attr_accessor :is_new

    def initialize(doc_hash=Hash.new, is_new=true)
      self.doc = doc_hash
      self.is_new = is_new
    end

    def doc=(hash)
      @doc = hash
    end

    def doc
      @doc
    end

    def [](k)
      @doc[k.to_s]
    end

    def []=(k,v)
      @doc[k.to_s] = v
    end

    def is_new?
      self.is_new == true
    end

    def to_json(*a)
      @doc.to_json
    end

    # Makes an insert call to the database for the instance of the document
    def insert
      return false unless is_new?
      _id = self.class.collection.insert(@doc)
      self.is_new = false

      return _id
    end

    # Update the document in the database with either a provided document
    # or use the instance's document
    #
    # @param [<Mote::Document>] update_doc Optional document to update with
    # @param [Hash] opts Options to send to the Mongo Driver along with the update
    def update(update_doc=@doc, opts)
      return false if is_new?
      self.class.collection.update({"_id" => @doc["_id"]}, update_doc, opts)
    end

  end
end

