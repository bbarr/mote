require "active_support/concern"

module Mote
  
  module Keys
    extend ActiveSupport::Concern
    extend self

    included do
      class_eval do
        
        # Create a key for the model
        def self.key(name, opts={})
          self.keys << name
          Mote::Keys.generate_key_methods(name)
        end

        # Collection of keys for the model
        def self.keys
          @keys ||= []
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
        hash.each do |k, v|
          if self.class.keys.include? k
            doc[k.to_s] = hash.delete(k)
          end
        end
      end

      hash.each do |k, v|
        instance_eval <<-"end_eval"
          instance_variable_set :@#{k}, v
        end_eval
      end
      
      return doc_hash
    end

  end

end
