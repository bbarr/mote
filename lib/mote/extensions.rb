# Overwrite the BSON object ID as_json and to_json methods
# so that when rendered as json it will simply use to_string
class BSON::ObjectId
  alias_method :original_to_json, :to_json

  def as_json(*a)
    to_s
  end

  def to_json(*a)
    as_json.to_json
  end
end

# Open up the Hash class to provide a stringify keys method to sanitize
# hashes before we create a Mote::Document.
#
# @see https://github.com/rails/rails/blob/master/activesupport/lib/active_support/core_ext/hash/keys.rb
class Hash

  # Creates a new hash with keys stringified
  def stringify_keys
    dup.stringify_keys!
  end

  # Loop through all keys and create a string key for each one
  # deleteing the old key and returning the hash
  #
  # @return [Hash] Stringified hash
  def stringify_keys!
    keys.each do |key|
      self[key.to_s] = delete(key)
    end
    self
  end
end
