## Setup ENV and require stuff
ENV['RACK_ENV'] = 'test'
require 'lib/boot'

class OwmwTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end


  ### Fixtures ...
  def an_access_point(hostname, common_name, mac_address)
    AccessPoint.new.load(
        :name => hostname,
        :mac_address => mac_address,
        :l2vpn_clients => [
            :identifier => common_name
        ]
    )
  end

  def an_online_user(mac_address)
    OnlineUser.new.load(
        :radius_accounting => {:calling_station_id => mac_address}
    )
  end


  ### Tests ...

  # Pending test, yet to implement
  #def test_retrieve_url_for_access_point_from_mac_address
  #  pending
  #  #OpenVpn.any_instance.stubs(:clients).returns [['cn_1', '1.2.3.4:5678', '4.3.2.1', '67264', '87264', 'Fri Jul 7 14:20:51 2006', '1152300051']]
  #  OpenVpn.any_instance.stubs(:users).returns [['A0:5E:11:22:22:44', 'cn_1', "1.2.3.4:4099", "Thu May 26 14:39:41 2011"]]
  #  AccessPoint.stubs(:find_by_associated_mac_address).returns an_access_point('cool_ap', 'cn_1', '00:11:22:33:44:55')
  #
  #  get '/access_points/55%3A44%3A33%3A22%3A11%3A00/urls.xml'
  #  assert last_response.ok?
  #  puts last_response.body
  #  assert last_response.body == [an_access_point('cool_ap', 'cn_1', '00:11:22:33:44:55')]
  #end


  def test_there_are_no_online_users_on_access_point
    AccessPoint.stubs(:find).returns an_access_point('cool_ap', 'cn_1', '00:11:22:33:44:55')
    OnlineUser.stubs(:find_by_mac_address).returns [an_online_user('55:44:33:22:11:00')]
    OpenVpn.any_instance.stubs(:users).returns [['A0:5E:11:22:22:44', 'cn_2', "1.2.3.4:4099", "Thu May 26 14:39:41 2011"]]

    get '/access_points/cool_ap/online_users.xml'
    assert last_response.ok?
    assert last_response.body == [].to_xml
  end

  def test_there_are_some_online_users_on_access_point
    AccessPoint.stubs(:find).returns an_access_point('cool_ap', 'cn_1', '00:11:22:33:44:55')
    OnlineUser.stubs(:all).returns [an_online_user('A0:5E:11:22:22:44')]
    OpenVpn.any_instance.stubs(:users).returns [['A0:5E:11:22:22:44', 'cn_1', "1.2.3.4:4099", "Thu May 26 14:39:41 2011"]]

    get '/access_points/cool_ap/online_users.xml'
    assert last_response.ok?
    assert last_response.body == [an_online_user('A0:5E:11:22:22:44')].to_xml
  end

  def test_online_users_but_access_point_not_found
    AccessPoint.stubs(:find).returns(nil)
    get '/access_points/non_existant_ap/online_users.xml'
    assert last_response.not_found?
  end
end
