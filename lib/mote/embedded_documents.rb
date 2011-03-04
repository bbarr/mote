module Mote

  # Handle logic behind embedding documents into another document
  module EmbeddedDocuments
    extend ActiveSupport::Concern
    include Mote::Keys
    
    module ClassMethods

      # Class macro for defining an embeds_many relationship
      # Used for delegating logic of an embedded document to another model to handle
      # its own logic
      #
      # This will create a key for the given model name
      #
      # @param [Symbol] name The name of the key to be created, will be interpretted as the model name
      def embeds_many(name)
        key name, :default => []
        embedded_docs << name
      end
      
      def embedded_docs
        @embedded_docs ||= []
      end
    end

    module InstanceMethods

      def instantiate_document(hash)
        super

        self.class.embedded_docs.each do |emb|
          arr = self.send(emb)
          unless arr.nil?
            model = embedded_collection_class(emb)
            arr.map! { |doc| model.new(doc) }
          end
        end
      end

      # Update prepare for insert to handle any embbedded documents in this model
      def prepare_for_insert(doc=@doc)
        doc = super
        
        self.class.embedded_docs.each do |emb|
          arr = self.send(emb)
          unless arr.nil?
            arr.map! { |doc| doc.prepare_for_insert }
          end
        end

        doc
      end

      private

      # Takes the symbol representing an embeds many relationship and retrieves
      # the class name for the model that each individual document is represented by
      #
      # @example
      #   class Blog < Mote::Document
      #     include Mote::Keys
      #     include Mote::EmbeddedDocuments
      #
      #     key :title
      #     embeds_many :posts
      #   end
      #
      #   class Post < Mote::EmbeddedDocument; end
      #
      #   embedded_collection_class(:posts) #=> Post
      # 
      # @param [Symbol] name Pluralized name representing the array of embedded docs
      # @return [Constant] The constant name of the class
      def embedded_collection_class(name)
        Kernel.const_get(name.to_s.singularize.capitalize)
      end
    end
  end
end
