# This file is part of the OpenWISP MiddleWare
#
# Copyright (C) 2012 OpenWISP.org
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

class OpenVpn

  @@openvpn_status_cache = ActiveSupport::Cache::MemoryStore.new(:expires_in => 3.seconds)

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
    
    @@openvpn_status_cache.fetch(config.to_s) do
      current = OpenVPNServer.new(Marshal.load(Marshal.dump(config)))
      connected = current.status
      current.destroy

      connected
    end
    
  rescue Exception => e
    $stderr.puts "Error processing vpn for configuration '#{config.inspect}': #{e}"
    
    []
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
