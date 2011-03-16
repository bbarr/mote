module Mote
  
  # Module for defining specific keys which are allowed in a document.  Any properties
  # found in has for a given Mote::Document will be relegated to instance variables
  module Keys
    extend ActiveSupport::Concern

    included do
      key :_id
    end

    module ClassMethods
      
      # Class macro for defining a key on a Mote::Document
      #
      # @param [Symbol] name The name of the key
      # @param [Hash] opts Options to go along with the key definition
      def key(name, opts={})
        self.keys[name.to_s] = Key.new(name, opts)
        generate_key_methods(name)
      end

      def keys
        @keys ||= {}
      end

      # Generates accessors and setters for a key on the model
      #
      # @param [String, Symbol] key_name The key name to generate methods for
      def generate_key_methods(key_name)
        define_method key_name do
          @doc["#{key_name}"]
        end

        define_method "#{key_name}=" do |value| 
          @doc["#{key_name}"] = value
        end
      end

    end

    module InstanceMethods

      # Override the instantiate document method so that it sets the document up based
      # on the keys defined in the model
      # 
      # @param [Hash] hash Document hash to process
      def instantiate_document(hash)
        self.doc = process_keys hash.stringify_keys

        # Assign a pk now if the document doesn't already have one
        self.class.collection.pk_factory.create_pk(self.doc)
      end

      # Overwrite the original prepare_for_insert method so that we can run through and
      # drop any keys in the hash that have a nil value to prevent nil keys from being
      # inserted into the database
      def prepare_for_insert(doc=@doc)
        super

        clean_doc = doc.dup
        self.class.keys.each { |key_name, key| clean_doc.delete(key_name) if clean_doc[key_name].nil? }
        clean_doc
      end

      private

      # Creates a hash of the keys the model has define and attemps to
      # create instance variables for any other left over hash key value pairs
      # 
      # @param [Hash] hash Hash to process
      def process_keys(hash)
        doc_hash = Hash.new.tap do |doc|
          self.class.keys.each do |key_name, key|
            doc[key.name] = hash.delete(key_name) || key.default
          end
        end

        hash.each do |k, v|
          instance_eval { instance_variable_set "@#{k}", v }
        end
        
        return doc_hash
      end

    end

    # Class for keys created on a document allowing for default options etc
    class Key

      attr_reader :name, :default

      def initialize(name, opts={})
        @name = name.to_s
        @default = opts.include?(:default) ? opts[:default] : nil
      end

    end

  end
end
