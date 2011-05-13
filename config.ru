require 'rubygems'
require 'bundler'

Bundler.require

# Standard Output and Standard Error are redirected
# to logfile
log = File.new('log/sinatra.log', 'a')
$stdout.reopen(log)
$stderr.reopen(log)

# Require necessary libs and settings
require 'config/settings'
require 'owmw'

# Autoload each model in models directory
Dir.glob("models/*").each {|model| load model}

# Enable basic auth for any resource
use Rack::Auth::Basic, "Restricted Area" do |username, password|
  [username, password] == [settings.owmw_username, settings.owmw_password]
end

run Sinatra::Application
