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

class OpenVpn

  def initialize(vpn_configs = nil)
    configs = vpn_configs || [vpn_defaults]
    @vpns = configs.map{ |config| prepare(config) }
  end

  def find_users_mac_addresses_by_cname(cname)
    users.select{ |connected_to_server| connected_to_server[1] == cname }.map{ |user| user[0] }
  end

  def find_client_cname_by_associated_mac_address(mac_address)
    users.select{ |connected_to_server| connected_to_server[0] == mac_address }.map{ |user| user[1] }.first
  end

  def clients
    @vpns.map{ |vpn| connected(vpn).first }.flatten(1)
  end

  def users
    @vpns.map{ |vpn| connected(vpn).last }.flatten(1)
  end

  private

  def connected(config)
    current = OpenVPNServer.new(Marshal.load(Marshal.dump(config)))
    connected = current.status
    current.destroy

    connected
  end

  def prepare(config)
    config = vpn_defaults.merge config
    new_config = {}

    config.each{ |key, val| new_config[key.to_s.capitalize] = val }
    new_config
  end

  def vpn_defaults
    {:host => "localhost", :port => 1234, :timeout => 10}
  end
end
