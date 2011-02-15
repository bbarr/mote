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

end
