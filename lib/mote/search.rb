require "mote/search_builder"
module Mote

  # Provides basic search functionality to a Mongo document by stemming words in the
  # supplied keys and creating an array of words to search off of
  #
  # Inspired by John Nunemaker's MongoMapper plugin Hunt
  # @see https://github.com/jnunemaker/hunt
  module Search
    extend ActiveSupport::Concern
    include Mote::Keys
    include Mote::Callbacks

    included do
      before_insert :build_search
      before_update :build_search
    end
    
    module ClassMethods
      
      # Class macro to identify fields to be able to search off of
      #
      # @param [Symbol, <Array> Symbol] keys Keys to search on
      def searches(*keys)
        key :search_terms
        @search_keys = keys
      end

      def search_keys
        @search_keys
      end

    end

    module InstanceMethods

      private

      # Build out an array of individual words for building out search on
      def flat_search_terms
        self.class.search_keys.collect { |key| send(key) }.flatten.join(' ')
      end

      # Build out the actual search array
      def build_search
        self.search_terms = SearchBuilder.stem_words flat_search_terms
      end

    end

  end
end
