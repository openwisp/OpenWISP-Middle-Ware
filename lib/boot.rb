# This file is part of the OpenWISP MiddleWare
#
# Copyright (C) 2011 CASPUR (wifi@caspur.it)
#
# This software is licensed under a Creative  Commons Attribution-NonCommercial
# 3.0 Unported License.
#   http://creativecommons.org/licenses/by-nc/3.0/
#
# Please refer to the  README.license  or contact the copyright holder (CASPUR)
# for licensing details.
#

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