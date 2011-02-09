require File.expand_path("../spec_helper", __FILE__)

describe Mote::Keys do
  
  class Author < Mote::Document
    include Mote::Keys

    attr_accessor :password

    key :name, :default => "Bill"
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

  it "should let you pass instance variables not related to the document" do
    @author = Author.new(:name => "Damian", :password => "pass")
    @author.doc.include?(:password).should be false
    @author.password.should == "pass"
  end

  it "should have a hash which represents the document still" do
    @author = Author.create(:name => "Damian", :password => "pass")
    @author.name.should == "Damian"
    @author.doc["name"].should == "Damian"
  end
  
  it "should have a valid document hash after finding" do
    @author = Author.create(:name => "Damian", :password => "pass")
    @a = Author.find_one(:name => "Damian")
    @a["name"].should == "Damian"
  end

  it "should set default attribute values if they exist and no value is provided" do
    @author = Author.new
    @author.name.should == "Bill"
  end

end
