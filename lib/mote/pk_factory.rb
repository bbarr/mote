module Mote

  # Custom PkFactory for generating an ID for Mote documents.
  # Hashes that are passed in will have a new attribute _id as a string
  # instead of a symbol which the default BSON::ObjectId generates
  # 
  # @param [Hash] doc Document being inserted into database
  module PkFactory
    def self.create_pk(doc)
      (doc.has_key?(:_id) && !doc[:_id].nil?) || (doc.has_key?('_id') && !doc["_id"].nil?) ? doc : doc.merge!("_id" => BSON::ObjectId.new)
    end
  end
end
