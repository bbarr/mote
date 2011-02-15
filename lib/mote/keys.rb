module Mote
  
  module Keys
    extend ActiveSupport::Concern

    module ClassMethods
      
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
      end

      # Define a method to retreive the document's _id attribute
      def _id
        @doc["_id"]
      end

      private

      # Creates a hash of the keys the model has define and attemps to
      # create instance variables for any other left over hash key value pairs
      # 
      # @param [Hash] hash Hash to process
      def process_keys(hash)
        doc_hash = 
        doc_hash = Hash.new.tap do |doc|
          self.class.keys.each do |key_name, key|
            if self.class.keys.include? key_name
              doc[key.name] = hash.delete(key_name) || key.default
            end
          end
        end

        doc_hash["_id"] = hash["_id"] if hash.include? "_id"
        
        hash.each do |k, v|
          instance_eval <<-"end_eval"
            instance_variable_set :@#{k}, v
          end_eval
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
