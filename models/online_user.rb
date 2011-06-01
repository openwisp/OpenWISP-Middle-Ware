class OnlineUser < ActiveResource::Base
  extend ActiveModel::Naming
  include ActiveModel::Serializers::Xml

  self.site = settings.owums_base_site
  self.user = settings.owums_operator
  self.password = settings.owums_password

  def self.find_by_mac_address(mac)
    OnlineUser.all.select{ |user| user.radius_accounting.calling_station_id == mac }.first
  end
end
