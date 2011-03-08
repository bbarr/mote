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
        embedded_docs << { name: name, kind: :many }
      end

      # Class macro for defining an embeds_one relationship
      # Used for delegating logic of an embedded document to another model to handle
      #
      # This will create a key for the given model name
      #
      # @param [Symbol] name The name of the key to be created, will be interpretted as the model name
      def embeds_one(name)
        key name
        embedded_docs << { name: name, kind: :one }
      end
      
      def embedded_docs
        @embedded_docs ||= []
      end
    end

    module InstanceMethods

      def instantiate_document(hash)
        super

        embedded_docs.each do |emb|
          embedded = self.send(emb[:name])
          unless embedded.nil?

            model = embedded_collection_class(emb[:name])

            if emb[:kind] == :many
              embedded.map! { |doc| model.new(doc) }
            else
              self.send("#{emb[:name]}=", model.new(embedded))
            end

          end
        end

      end

      # Update prepare for insert to handle any embbedded documents in this model
      def prepare_for_insert(doc=@doc)
        doc = super
        
        embedded_docs.each do |emb|
          embedded = self.send(emb[:name])

          unless embedded.nil?
            if emb[:kind] == :many
              doc[emb[:name].to_s].map! { |emb_doc| emb_doc.prepare_for_insert }
            else
              doc[emb[:name].to_s] = doc[emb[:name].to_s].prepare_for_insert
            end
          end
        end

        return doc
      end

      private

      def embedded_docs
        self.class.embedded_docs
      end

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

      # Reuseable method to process an embedded document or collection of embedded documents
      #
      # Will yield the block for each embedded document found
      def process_embedded(debug=false, &block)
        self.class.embedded_docs.each do |emb|
          embedded = self.send(emb[:name])
          unless embedded.nil?
            if emb[:kind] == :many
              embedded.map! { |doc| yield(doc, emb) }
            else
              transformed = yield(embedded, emb)
              self.send("#{emb[:name]}=".to_sym, transformed)
            end
          end
        end
      end
    end
  end
end
