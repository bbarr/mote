require File.expand_path("../spec_helper", __FILE__)

describe Mote::Search do
  
  class SingleSearchTerm < Mote::Document
    include Mote::Search

    key :title
    key :description

    searches :title
  end

  class CompoundSearch < Mote::Document
    include Mote::Search

    key :title
    key :description

    searches :title, :description
  end

  before do
    document = { :title => "Book Title", :description => "Foo Bar" }
    @single = SingleSearchTerm.create document
    @compound = CompoundSearch.create document
  end

  after do
    SingleSearchTerm.collection.drop
    CompoundSearch.collection.drop
  end

  it "should return a string of all the words in the search keys" do
    @single.send(:flat_search_terms).should == "Book Title"
    @compound.send(:flat_search_terms).should == "Book Title Foo Bar"
  end

  it "should have an array of search terms" do
    @single.send(:build_search).should == %w{book titl}
    @compound.send(:build_search).should == %w{book titl foo bar}
  end

end
