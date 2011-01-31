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

        def self.keys
          @keys ||= []
        end

      end
    end

    # Generates accessors and setters for a key on the model
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
  end

end
