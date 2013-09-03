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

require 'rubygems'
require 'bundler'

Bundler.setup

Bundler.require :default
Bundler.require :development if development?
Bundler.require :test if test?

# Require necessary libs and settings
require 'config/settings'
require 'owmw'

# Require extra libs
Dir.glob("lib/extras/*").each {|lib| require lib}
# Require each model in models directory
Dir.glob("models/*").each {|model| require model}