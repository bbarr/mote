require File.expand_path("../spec_helper", __FILE__)

describe Mote::Document do
  
  before do
    @book = Book.new(:name => "War and Peace")
  end

  after do
    Book.collection.drop
  end

  it "should generate a collection name from the model name" do
    Book.collection_name.should == "books"
  end

  it "should insert a new document" do
    @book.insert.should be_a(BSON::ObjectId)
  end
  
  it "should reject insert on not new" do
    @book.insert
    @book.insert.should be(false)
  end

  it "should find one by id" do
    @book.insert
    Book.find_one(@book["_id"]).should == @book
  end

  specify "create method" do
    @book = Book.create(:name => "War and Peace")
    @book.should be_a(Book)
    @book.is_new.should be(false)
  end

  it "should access a document hash's attribute through the object" do
    @book[:name].should == "War and Peace"
  end
  
  it "should be able to access document properties through method missing" do
    @book.name.should == "War and Peace"
  end

  it "should determine whether or not a module is included" do
    @book.keys?.should be false
    @book.callbacks?.should be true
  end

  describe "JSON custom methods" do

    before do
      @book = Book.new(:name => "War and Peace", :publisher => "Russkii Vestnik", :author => "Leo Tolstoy")
    end

    it "should call my_special_method when rendering json" do
      @book.should_receive :my_special_method
      @book.as_json(:methods => [:my_special_method])
    end

    it "should provide a serialized hash for the Mote::Document" do
      json_hash = @book.as_json
      json_hash.should be_a Hash
      json_hash.should include "name"
    end

    it "should provide a serialized hash with a key and value for the my_special_method" do
      json_hash = @book.as_json(:methods => [:my_special_method])
      json_hash.should include "my_special_method"
      json_hash["my_special_method"].should == "foo:bar"
    end

    it "should only fetch attributes specified in only" do
      hash = @book.send :serialize, :only => :name
      hash.should include "name"
      hash.should_not include "publisher"
      hash.should_not include "author"

      hash = @book.send :serialize, :only => [:name, :author]
      hash.should include "name"
      hash.should include "author"
      hash.should_not include "publisher"
    end

    it "should fetch all attribute except the ones specified" do
      hash = @book.send :serialize, :except => :publisher
      hash.should include "name"
      hash.should include "author"
      hash.should_not include "publisher"
    end
  end
  
end
