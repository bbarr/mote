require File.expand_path("../spec_helper", __FILE__)
require "mote/search_builder"

describe Mote::SearchBuilder do
  
  def filter_words(str)
    Mote::SearchBuilder.filter_words(str)
  end

  it "should strip any punctuation from the words" do
    Mote::SearchBuilder.strip_punctuation("Some!!!!!!").should == "Some"
  end

  it "should filter words that are less than 2 letters" do
    filter_words("A").should == []
  end

  it "should make all words lowercase" do
    filter_words("Some DAY").should == ["some", "day"]
  end

  it "should only supply unique words" do
    filter_words("One One One").should == ["one"]
  end

end
