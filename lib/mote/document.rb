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

      # Find all of the documents in a collection
      def all
        find
      end

      # Quickly create a document, inserting it to the collection immediately
      # 
      # @param [Hash] doc_hash Hash which represents the document to be inserted
      def create(doc_hash)
        doc = self.new(doc_hash, true)
        doc.insert

        return doc
      end

    end

    attr_accessor :is_new 

    def initialize(doc_hash=Hash.new, is_new=true)
      if keys?
        self.doc = process_keys doc_hash.stringify_keys
      else
        self.doc = doc_hash.stringify_keys
      end

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

    def as_json(options={})
      serialize(options)
    end

    def to_json(options={})
      as_json(options)
    end

    # Compare Mote::Documents based off the _id of the document
    #
    # @param [Document] other The other document to compare with
    def ==(other)
      return false unless other.is_a?(self.class)
      @doc["_id"] == other["_id"]
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

    # Saves the current state of the document into the database
    def save
      is_new? ? insert : update
    end

    # Provide access to document keys through method missing
    # Check whther a module is included in the model through methods such as
    # keys? or callbacks?
    def method_missing(method_name, *args, &block)
      if @doc and @doc.include? method_name.to_s
        @doc[method_name.to_s]
      elsif Mote::MOTE_MODULES.collect { |m| m.to_s.downcase + "?" }.include? method_name.to_s
        module_name = method_name.to_s.gsub(/\?/, '').capitalize
        self.class.include? Mote.const_get(module_name)
      else
        super
      end
    end

    private

    # Serialize a Mote::Document
    #
    # The basis for this method was borrowed from ActiveModel's Serialization#serializable_hash
    # @see ActiveSupport::Serialization#serialiazable_hash
    #
    # Allows the user to specify methods on the model to call when serializing
    #
    # == Note
    # Only one of the 2 exclusion options (only or except) will be used, the 2 cannot be passed together
    # If both are passed, only will take precedence
    #
    # @param [Hash] options Options to serialize with
    # @option options [Symbol, Array <Symbol>] :only Specify specific attributes to include in serialization
    # @option options [Symbol, Array <Symbol>] :except Specify methods to exclude during serialization
    # @option options [Symbol, Array <Symbol>] :methods Model instance methods to call and include their result in serialization
    def serialize(options=nil)
      options ||= {}
      keys = @doc.keys

      only   = Array.wrap(options[:only]).map(&:to_s)
      except = Array.wrap(options[:except]).map(&:to_s)

      if only.any?
        keys &= only
      elsif except.any?
        keys -= except
      end

      method_names = Array.wrap(options[:methods]).map { |n| n if respond_to?(n) }.compact
      Hash[(keys + method_names).map { |n| [n.to_s, send(n)] }]
    end

  end
end
