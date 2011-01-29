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
