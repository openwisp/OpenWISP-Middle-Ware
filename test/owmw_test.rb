require 'sinatra'
require 'test/unit'
require 'rack/test'
require 'redgreen'
Dir.glob(File.join('**', 'owmw')).each{ |app| require app }

set :environment, :test

class OwmwTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_truth
    assert true
  end
end
