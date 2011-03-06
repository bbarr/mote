require "bundler"
Bundler.require(:default, :development, :test)

require "simplecov"
SimpleCov.start

require File.join(File.dirname(__FILE__), "../lib/mote.rb")
require File.join(File.dirname(__FILE__), "test_case.rb")

Mote.configure do |config|
  config.db = Mongo::Connection.new.db("mote_test", :pk => Mote::PkFactory)
end

Rspec.configure do |config|
  config.after(:each) { Book.collection.drop }
end
