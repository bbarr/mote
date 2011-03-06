#require File.expand_path "../../lib/mote.rb", __FILE__

class Book < Mote::Document
  include Mote::Callbacks

  def my_before_insert
  end

  def my_special_method
    "foo:bar"
  end

end
