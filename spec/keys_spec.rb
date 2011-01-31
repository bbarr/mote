require File.expand_path("../spec_helper", __FILE__)

describe Mote::Keys do
  
  class Author < Mote::Document
    include Mote::Keys

    key :name
  end

  before do
    @author = Author.new(:name => "Damian")
  end

  it "should have a key method" do
    Author.should respond_to(:key)
  end

  it "should have a key of name" do
    @author.should respond_to(:name)
    @author.should respond_to(:name=)
    @author.name.should == @author["name"]
  end

  it "should let you specify the attribute name through a method" do
    @author.name = "Galarza"
    @author.name.should == "Galarza"
    @author["name"].should == "Galarza"
  end

end
