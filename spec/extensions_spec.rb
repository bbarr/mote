require File.expand_path("../spec_helper", __FILE__)

describe "Extensions" do
  
  describe "ObjectId" do
    specify "as_json should generate the ObjectId as a string" do
      id = BSON::ObjectId.new
      id.as_json.should == id.to_s
    end
  end

  describe "Hash" do
    it "should duplicate the hash" do
      original = { :key_one => "One" }
      stringified = original.stringify_keys
      
      original.should_not == stringified
    end

    it "should not have any keys as symbols anymore" do
      original = { :key_one => "One" }
      original = original.stringify_keys

      original[:key_one].should be(nil)
      original["key_one"].should == "One"
    end
  end

end
