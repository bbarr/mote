require File.expand_path "../../lib/mote.rb", __FILE__

Mote.db = Mongo::Connection.new.db("mote_test", :pk => Mote::PkFactory)

class Book < Mote::Document
  include Mote::Callbacks

  def my_before_save
  end
end
