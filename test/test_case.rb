require File.expand_path "../../lib/mote.rb", __FILE__

Mote.db = Mongo::Connection.new.db("mote_test")

class Book < Mote::Document
  
end
