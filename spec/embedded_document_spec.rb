require File.expand_path("../spec_helper", __FILE__)

describe Mote::EmbeddedDocuments do

  class Blog < Mote::Document
    include Mote::Keys
    include Mote::EmbeddedDocuments

    key :title
    embeds_many :posts
    embeds_one :author
  end

  class Post < Mote::Document
    include Mote::Keys

    key :title
    key :content
  end

  class Author < Mote::Document
    include Mote::Keys

    key :name
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

    it "should have a class macro for embedding a single doc" do
      Blog.should respond_to :embeds_one
    end

    it "should include posts in the embedded_docs" do
      Blog.embedded_docs.should include({ :name => :posts, :kind => :many })
    end

    it "should create instances of Post for each post embedded" do
      @blog = Blog.new(:title => "My blog", :posts => [ { :title => "post one", :content => "klakda"}, {:title => "post two", :content => "lskldk" }])
      @blog.posts.should be_a Array
      @blog.posts.each { |post| post.should be_a Post }
    end

    it "should allow you to insert into the database" do
      @blog = Blog.create(:title => "My blog", :posts => [ { :title => "post one", :content => "klakda"}, {:title => "post two", :content => "lskldk" }])
    end

    it "should should create an instance of Author for the post author" do
      @blog = Blog.new(:title => "My blog", :author => { name: "Damian" })
      @blog.author.should be_a Author
      @blog.insert
    end

  end

  describe "embeds_many (Posts)" do

    before do
      @blog = Blog.new(:title => "My blog", :posts => [ { :title => "post one", :content => "klakda"}, {:title => "post two", :content => "lskldk" }])
    end

    specify "valid hash for insert into parent" do
      @blog.prepare_for_insert.should be_a Hash
    end
  end
  
end

