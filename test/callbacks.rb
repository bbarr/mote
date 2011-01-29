require "test/unit"
require File.expand_path "../test_case.rb", __FILE__

class CallbackTest < Test::Unit::TestCase
  
  def test_callback_added
    assert_send [Book, :before_save, 1]
  end

  def test_callback_method
    book = Book.create(:name => "War and Peace")
    assert_send [book, :some_func]
  end
end
