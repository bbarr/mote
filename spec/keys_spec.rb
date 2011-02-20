require File.expand_path("../spec_helper", __FILE__)

describe Mote::Keys do
  
  class Author < Mote::Document
    include Mote::Keys

    attr_accessor :password

    key :name, :default => "Bill"
    key :active, :default => false
    key :position
  end

  before do
    @author = Author.new(:name => "Damian")
  end

  it "should have a key method" do
    Author.should respond_to(:key)
  end

  it "should have an _id method" do
    @author.should respond_to :_id
  end

  it "should allow for false boolean value for default" do
    @author.active.should be false
  end

  describe "New Documents" do
    it "should have a key of name" do
      @author.should respond_to(:name)
      @author.should respond_to(:name=)
      @author.name.should == @author["name"]
    end

    it "should let you specify the attribute name through a method" do
      @author.should_not_receive :method_missing
      @author.name = "Galarza"
      @author.name.should == "Galarza"
      @author["name"].should == "Galarza"
    end

    it "should let you pass instance variables not related to the document" do
      @author = Author.new(:name => "Damian", :password => "pass")
      @author.doc.include?(:password).should be false
      @author.password.should == "pass"
    end

    it "should have a hash which represents the document still" do
      @author = Author.create(:name => "Damian", :password => "pass")
      @author.name.should == "Damian"
      @author.doc["name"].should == "Damian"
    end
    
    it "should have a valid document hash after finding" do
      @author = Author.create(:name => "Damian", :password => "pass")
      @a = Author.find_one(:name => "Damian")
      @a["name"].should == "Damian"
    end

    it "should set default attribute values if they exist and no value is provided" do
      @author = Author.new
      @author.name.should == "Bill"
    end

    it "should access the _id in the doc" do
      @author = Author.create(:name => "Damian")
      @author["_id"].should be_a BSON::ObjectId
    end
  end

  describe "Find documents" do
    it "should have access to the document's id" do
      @author.insert
      @a = Author.find_one(:name => @author.name)
      @a["_id"].should be_a BSON::ObjectId
    end
  end

  it "should not store nil keys in the database" do
    @author.insert
    raw_author = Author.collection.find_one(@author._id)
    raw_author.should_not include "position"
  end

end
