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

  specify "attributes by method call" do
    @book.insert
    @book.name.should == @book["name"]
  end

  specify "create method" do
    @book = Book.create(:name => "War and Peace")
    @book.should be_a(Book)
    @book.is_new.should be(false)
  end

  it "should access a document hash's attribute through the object" do
    @book[:name].should == "War and Peace"
  end

end
