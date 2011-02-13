require File.expand_path("../spec_helper", __FILE__)

describe Mote::Callbacks do
  
  before do
  end

  after do
    Book.collection.drop
  end

  it "should add callback methods" do
    Book.should respond_to :before_insert
  end

  it "should call my_before_insert before save" do
    Book.before_insert :my_before_insert
    @book = Book.new(:name => "War and Peace")

    @book.should_receive :my_before_insert
    @book.insert
  end
end
