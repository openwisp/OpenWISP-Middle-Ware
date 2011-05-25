## Setup ENV and require stuff
ENV['RACK_ENV'] = 'test'
require 'lib/boot'

class OwmwTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end



  ### Fixtures ...
  def an_access_point
    AccessPoint.new.load(
        :name => 'cool_ap_name',
        :mac_address => '00:11:22:33:44:55',
        :l2vpn_clients => [
            :identifier => 'l2vpn_common_name'
        ]
    )
  end

  def no_online_users
    [OnlineUser.new.load({})]
  end

  def some_online_users(mac_address)
    OnlineUser.new.load(
        :radius_accounting => {:calling_station_id => (mac_address)}
    )
  end


  ### Tests ...
  def test_there_are_no_online_users_on_access_point
    AccessPoint.expects(:find).returns(an_access_point)
    OnlineUser.expects(:all).returns(no_online_users)
    OpenVpn.expects(:new).returns(['0', 'l2vpn_common_name'])

    get '/access_points/cool_ap_name/online_users.xml'
    assert last_response.ok?
    assert last_response.body == [].to_xml
  end

  def test_online_users_but_access_point_not_found
    AccessPoint.expects(:find).returns(nil)
    get '/access_points/non_existant_ap/online_users.xml'
    assert last_response.not_found?
  end
end
