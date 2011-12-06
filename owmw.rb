# This file is part of the OpenWISP MiddleWare
#
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

get %r{\/access_points(\/|\/\/|\/all\/)associated_users.xml} do
  @associated_users = []
  online_users = OnlineUser.all

  AccessPoint.all.each do |access_point|
    access_point.associated_mac_addresses.each do |mac_address|
      user = OnlineUser.find_by_mac_address(mac_address, online_users)

      if user
        user.access_point_id = access_point.id
        @associated_users << user
      end
    end
  end

  @associated_users.compact.to_xml
end

get '/access_points/:name/associated_users.xml' do
  access_point = AccessPoint.find(params[:name])
  online_users = OnlineUser.all

  if access_point
    @associated_users = []

    access_point.associated_mac_addresses.each do |mac_address|
      user = OnlineUser.find_by_mac_address(mac_address, online_users)

      if user
        user.access_point_id = access_point.id
        @associated_users << user
      end
    end

    @associated_users.compact.to_xml
  else
    404
  end
end

get '/associated_users/:mac_address.xml' do
  vpn_server = OpenVpn.new(settings.vpns_to_scan)
  cn = vpn_server.find_client_cname_by_associated_mac_address(params[:mac_address])

  @associated_user = AssociatedUser.new.load(
    :access_point => AccessPoint.find(cn)
  )

  if @associated_user
    @associated_user.to_xml
  else
    404
  end
end
