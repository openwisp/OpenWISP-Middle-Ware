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
