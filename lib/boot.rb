require 'rubygems'
require 'bundler'

Bundler.setup

Bundler.require :default
Bundler.require :development if development?
Bundler.require :test if test?

# Require necessary libs and settings
require 'config/settings'
require 'owmw'

# Require each model in models directory
Dir.glob("models/*").each {|model| require model}