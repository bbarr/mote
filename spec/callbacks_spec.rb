require File.expand_path("../spec_helper", __FILE__)

describe Mote::Callbacks do
  
  before do
  end

  after do
    Book.collection.drop
  end

  it "should add callback methods" do
    Book.should respond_to :before_save
  end

  it "should call my_before_save before save" do
    Book.before_save :my_before_save
    @book = Book.new(:name => "War and Peace")

    @book.should_receive :my_before_save
    @book.insert
  end
end
