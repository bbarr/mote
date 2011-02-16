require File.expand_path("../spec_helper", __FILE__)

describe Mote::Cursor do
  
  before do
    5.times { |i| Book.create(:name => "Book #{i}") }
  end

  after do
    Book.collection.drop
  end

  it "should return an array of Mote::Documents" do
    books = Book.all.to_a
    books.each do |book|
      book.should be_a(Book)
    end
  end

  it "should proxy any undefined methods to the Mongo::Cursor object" do
    books = Book.all
    books.should be_a Mote::Cursor
    books.skip(1)
  end

  it "should respond to Mongo::Cursor methods" do
    books = Book.all
    books.should respond_to :skip
  end

  it "should update the mongo_cursor with the return of a Mongo::Cursor proxied method" do
    books = Book.find
    original_cursor = books.instance_variable_get("@mongo_cursor").dup

    books.skip(1)
    original_cursor.should_not be books.instance_variable_get("@mongo_cursor")
  end

  it "should return the Mote::Cursor instance when Mongo::Cursor methods return the cursor" do
    books = Book.find().skip(1)
    books.should be_a Mote::Cursor
  end

  it "should return the result of the Mongo::Cursor method if it does not return a cursor" do
    books=  Book.find
    books.close.should be true
  end
  
end
