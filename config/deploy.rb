# This file is part of the OpenWISP MiddleWare
#
# Copyright (C) 2012 OpenWISP.org
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# =============================================================================
# GENERAL SETTINGS
# =============================================================================

set :application,  "owmw"
set :deploy_to,  "/var/rails/#{application}"
set :rails_env, "production"

set :scm, :subversion
set :deploy_via, :export
set :repository, "https://spider.caspur.it/svn/owmw/trunk"

set :rvm_ruby_string, 'ree'

# Source hosts from config/deploy directory (exclude example host)
set :stages, Dir.glob('config/deploy/*').map{|s| File.basename(s)}.reject{|s| s == 'example.host.it'}

# =============================================================================
# CAP RECIPES
# =============================================================================

# Capistrano multistage
require 'capistrano/ext/multistage'

# Colorize capistrano output
require 'capistrano_colors'

# Note this happens after the general settings have been defined
require 'rubygems'

# Utility methods from cap_recipes
require 'cap_recipes/tasks/utilities'
extend Utilities

# RVM
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require 'rvm/capistrano'

# RUBYGEMS
require 'cap_recipes/tasks/rubygems'
set :rubygem_paths, "/usr/local/bin/gem"

# BUNDLER
require 'bundler/capistrano'

# SINATRA
after "deploy:restart", "sinatra:repair_permissions" # fix the permissions to work properly

# PASSENGER
require 'cap_recipes/tasks/passenger'

# CUSTOM RECIPES
load 'lib/recipes/sinatra'
load 'lib/recipes/deploy'
