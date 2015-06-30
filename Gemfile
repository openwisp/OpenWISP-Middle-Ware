source :rubygems

gem "sinatra"

gem "activemodel", :require => 'active_model'
gem "activeresource", :require => 'active_resource'

gem "openVPNServer", '0.0.2', :git => 'https://github.com/openwisp/openVPNServer.git'

# Deploy with Capistrano
gem 'capistrano', '~> 2.9.0', :require => false
gem 'capistrano-ext', '~> 1.2.1', :require => false
gem 'cap-recipes', '~> 0.3.36', :require => false
gem 'capistrano_colors', '~> 0.5.4', :require => false

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
