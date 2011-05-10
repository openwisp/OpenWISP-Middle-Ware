require 'rubygems'
require 'bundler'

Bundler.require

# Autoload each model in models directory
Dir.glob("models/*").each do |model_file|
  model_name = ":#{File.basename(model_file, '.rb').capitalize}"
  autoload eval(model_name), model_file
end

# Standard Output and Standard Error are redirected
# to logfile
log = File.new('log/sinatra.log', 'a')
$stdout.reopen(log)
$stderr.reopen(log)

# Require necessary libs and settings
require 'config/settings'
require 'owmw'

run Sinatra::Application
