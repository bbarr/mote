require File.expand_path("../spec_helper", __FILE__)

describe Mote::EmbeddedDocuments do

  class Blog < Mote::Document
    include Mote::Keys
    include Mote::EmbeddedDocuments

    key :title
    embeds_many :posts
  end

  class Post < Mote::Document
    include Mote::Keys

    key :title
    key :content
  end


  describe "Parent (Blog)" do

    before do
      @blog = Blog.create(:title => "My Blog")
    end

    it "should have a class macro embeds_many" do
      Blog.should respond_to :embeds_many
    end

    it "should have an array of embedded docs" do
      Blog.should respond_to :embedded_docs
    end

    it "should include posts in the embedded_docs" do
      Blog.embedded_docs.should include :posts
    end

    it "should create instances of Post for each post embedded" do
      @blog = Blog.new(:title => "My blog", :posts => [ { :title => "post one", :content => "klakda"}, {:title => "post two", :content => "lskldk" }])
      @blog.posts.should be_a Array
      @blog.posts.each { |post| post.should be_a Post }
    end

    it "should allow you to insert into the database" do
      @blog = Blog.create(:title => "My blog", :posts => [ { :title => "post one", :content => "klakda"}, {:title => "post two", :content => "lskldk" }])
    end

  end
  
end
