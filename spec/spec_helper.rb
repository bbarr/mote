require "bundler"
Bundler.require(:default, :development, :test)

require "simplecov"
SimpleCov.start

require File.join(File.dirname(__FILE__), "../lib/mote.rb")
require File.join(File.dirname(__FILE__), "test_case.rb")

Rspec.configure do |config|
  config.after(:each) { Book.collection.drop }
end
