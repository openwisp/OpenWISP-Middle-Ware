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
