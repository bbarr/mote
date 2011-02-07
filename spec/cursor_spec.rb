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

end
