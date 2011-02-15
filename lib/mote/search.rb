module Mote

  # Provides basic search functionality to a Mongo document by stemming words in the
  # supplied keys and creating an array of words to search off of
  #
  # Inspired by John Nunemaker's MongoMapper plugin Hunt
  # @see https://github.com/jnunemaker/hunt
  module Search

    included do
      class_eval do

        # Class macro to identify fields to be able to search off of
        #
        # @param [Symbol, <Array> Symbol] keys Keys to search on
        def self.searches(*keys)
          key :search_terms
          @search_keys = keys
        end

        def self.search_keys
          @search_keys
        end

      end

      before_insert :build_search
      before_update :build_search

    end
    
    # Build out an array of individual words for building out search on
    def flat_search_terms
      self.class.search_terms.collect { |key| send(key) }.flatten.join(' ')
    end

    # Build out the actual search array
    def build_search
      self.searches = SearchBuilder.stem_words flat_search_terms
    end

  end
end
