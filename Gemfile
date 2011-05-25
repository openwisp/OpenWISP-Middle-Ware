source :rubygems

gem "sinatra"

gem "activemodel", :require => 'active_model'
gem "activeresource", :require => 'active_resource'

gem "openVPNServer"

group :development do
  ### Use shotgun to run server in development ###
  gem "shotgun"
end

group :test do
  ### Required for testing
  gem 'rake'
  gem 'test-unit', :require => 'test/unit'
  gem 'rack-test', :require => 'rack/test'
  gem 'mocha'
end
