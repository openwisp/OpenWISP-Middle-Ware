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

class OnlineUser < ActiveResource::Base
  extend ActiveModel::Naming
  include ActiveModel::Serializers::Xml

  self.site = settings.owums_base_site
  self.user = settings.owums_operator
  self.password = settings.owums_password

  def self.find_by_mac_address(mac, users)
    users.select{ |user| user.radius_accounting.calling_station_id == mac }.first
  end
end
