require File.expand_path("../spec_helper", __FILE__)

describe Mote::PkFactory do
  
  it "should have a create_pk method" do
    Mote::PkFactory.should respond_to :create_pk
  end

  it "should update the document hash to contain the unique id generated" do
    @doc = {"name" => "foo"}
    Mote::PkFactory.create_pk(@doc)
    @doc.should include "_id"
  end

  it "should not change the unique id on a document if it already has one" do
    @doc = {"name" => "foo"}
    Mote::PkFactory.create_pk(@doc)
    @doc.should_not_receive :merge!
    Mote::PkFactory.create_pk(@doc)
  end

end
