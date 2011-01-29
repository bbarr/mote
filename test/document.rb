require "test/unit"
require File.expand_path "../test_case.rb", __FILE__

class DocumentTest < Test::Unit::TestCase

  def setup

  end

  def teardown
    Book.collection.drop
  end
  
  def test_collection_name
    assert_equal("books", Book.collection_name)
  end

  def test_insert_new_document
    book = Book.new(:name => "War and Peace")
    assert_instance_of BSON::ObjectId, book.insert
  end

  def test_reject_insert_on_not_new
    book = Book.new(:name => "War and Peace")
    book.insert
    assert_equal(false, book.insert)
  end

  def test_find_one
    book = Book.new(:name => "War and Peace")
    book.insert
    assert_equal(book, Book.find_one(book["_id"]))
  end

  def test_attribute_by_method
    book = Book.new(:name => "War and Peace")
    book.insert

    assert_equal(book["name"], book.name)
  end
  
  def test_create_method
    book = Book.create(:name => "War and Peace")
    assert_instance_of(Book, book)
  end

end
