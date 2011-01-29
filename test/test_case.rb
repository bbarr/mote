require File.expand_path "../../lib/mote.rb", __FILE__

Mote.db = Mongo::Connection.new.db("mote_test")

class Book < Mote::Document
  include Mote::Callbacks

  before_save :some_func 

  def some_func
    p "Hello World"
  end

end
