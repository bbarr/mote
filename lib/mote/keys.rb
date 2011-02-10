require "active_support/concern"

module Mote
  
  module Keys
    extend ActiveSupport::Concern
    extend self

    included do
      class_eval do
        
        # Create a key for the model
        def self.key(name, opts={})
          self.keys[name.to_s] = Key.new(name, opts)
          Mote::Keys.generate_key_methods(name)
        end

        # Collection of keys for the model
        def self.keys
          @keys ||= {}
        end

        # Creates a method to retrieve the document's _id
        class_eval do
          def _id
            @doc["_id"]
          end
        end
        
      end
    end

    # Generates accessors and setters for a key on the model
    #
    # @param [String, Symbol] key_name The key name to generate methods for
    def generate_key_methods(key_name)
      module_eval <<-"end_eval"
        def #{key_name}
          @doc["#{key_name}"]
        end

        def #{key_name}=(value)
          @doc["#{key_name}"] = value
        end
      end_eval
    end

    # Creates a hash of the keys the model has define and attemps to
    # create instance variables for any other left over hash key value pairs
    # 
    # @param [Hash] hash Hash to process
    def process_keys(hash)
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
