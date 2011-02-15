module Mote

  # Utility methods for building out a search on a document
  module SearchBuilder

    def filter_words(word)
      word.to_s
        .downcase

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
