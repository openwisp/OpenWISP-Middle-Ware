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
