require 'bundler'
require 'sinatra'
require 'rspec'
require 'rack/test'

require File.join(File.dirname(__FILE__), '../client')
require File.join(File.dirname(__FILE__), '../lib/wmbind')

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
end
