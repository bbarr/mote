require "fast_stemmer"

module Mote

  # Utility methods for building out a search on a document
  module SearchBuilder
    extend self

    def filter_words(str)
      str
        .split(' ')
        .map(&:downcase)
        .reject { |word| word.size < 2 }
        .map { |word| strip_punctuation(word) }
        .reject { |word| word.blank? }
        .uniq

    end

    def stem_words(value)
      filter_words(value).map { |word| Stemmer.stem_word word }
    end

    # Strip any punctuation from the string
    def strip_punctuation(value)
      value.to_s.gsub(/[^a-zA-Z0-9]/, '')
    end

  end

end
