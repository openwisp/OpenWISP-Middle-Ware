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

class AccessPoint < ActiveResource::Base
  extend ActiveModel::Naming
  include ActiveModel::Serializers::Xml

  self.site = settings.owm_base_site
  self.user = settings.owm_operator
  self.password = settings.owm_password

  def associated_mac_addresses
    l2vpn_clients.map{ |l2vpn|
      vpn = OpenVpn.new(settings.vpns_to_scan)
      vpn.find_users_mac_addresses_by_cname(l2vpn.identifier)
    }.flatten(1)
  end
end
