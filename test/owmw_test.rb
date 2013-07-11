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

## Setup ENV and require stuff
ENV['RACK_ENV'] = 'test'
require 'lib/boot'

class OwmwTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end


  ### Fixtures ...
  def an_access_point(hostname, common_name, mac_address, site_url='http://openwisp.org')
    AccessPoint.new.load(
        :name => hostname,
        :mac_address => mac_address,
        :access_point_group => {
            :site_url => site_url
        },
        :l2vpn_clients => [
            :identifier => common_name
        ]
    )
  end

  def an_associated_user(mac_address)
    AssociatedUser.new.load(
        :radius_accounting => {:calling_station_id => mac_address}
    )
  end


  ### Tests ...
  
  
  # Pending test, yet to implement
  def test_retrieve_url_for_access_point_from_mac_address_but_none_found
    OpenVpn.any_instance.stubs(:users).returns []
    AccessPoint.stubs(:find).returns(nil)

    get '/associated_users/A0%3A5E%3A11%3A22%3A22%3A44/access_point.xml'
    assert last_response.not_found?
  end

  def test_retrieve_url_for_access_point_from_mac_address
    OpenVpn.any_instance.stubs(:users).returns [['A0:5E:11:22:22:44', 'cn_1', "1.2.3.4:4099", "Thu May 26 14:39:41 2011"]]
    AccessPoint.stubs(:find).returns an_access_point('cool_ap', 'cn_1', '00:11:22:33:44:55', 'http://google.com')

    get '/associated_users/A0%3A5E%3A11%3A22%3A22%3A44/access_point.xml'
    assert last_response.ok?
    assert last_response.body == an_access_point('cool_ap', 'cn_1', '00:11:22:33:44:55', 'http://google.com').to_xml
  end

  def test_there_are_no_associated_users_on_access_point
    AccessPoint.stubs(:find).returns an_access_point('cool_ap', 'cn_1', '00:11:22:33:44:55')
    AssociatedUser.stubs(:find_by_mac_address).returns [an_associated_user('55:44:33:22:11:00')]
    OpenVpn.any_instance.stubs(:users).returns [['A0:5E:11:22:22:44', 'cn_2', "1.2.3.4:4099", "Thu May 26 14:39:41 2011"]]

    get '/access_points/cool_ap/associated_users.xml'
    assert last_response.ok?
    assert last_response.body == [].to_xml
  end

  def test_there_are_some_associated_users_on_access_point
    AccessPoint.stubs(:find).returns an_access_point('cool_ap', 'cn_1', '00:11:22:33:44:55')
    AssociatedUser.stubs(:all).returns [an_associated_user('A0:5E:11:22:22:44')]
    OpenVpn.any_instance.stubs(:users).returns [['A0:5E:11:22:22:44', 'cn_1', "1.2.3.4:4099", "Thu May 26 14:39:41 2011"]]

    get '/access_points/cool_ap/associated_users.xml'
    assert last_response.ok?
    assert last_response.body == [an_associated_user('A0:5E:11:22:22:44')].to_xml
  end

  def test_associated_users_but_access_point_not_found
    AccessPoint.stubs(:find).returns(nil)
    get '/access_points/non_existant_ap/associated_users.xml'
    assert last_response.not_found?
  end
end
