class OpenVpn
  attr_reader :clients

  def initialize(vpn_configs)
    @clients = vpn_configs.map{ |vpn| vpn_clients_of vpn }.flatten(1)
  end

  private

  def vpn_clients_of(config)
    current = OpenVPNServer.new vpn_config(config)
    clients = current.status.last
    current.destroy

    clients
  end

  def vpn_config(config)
    config = vpn_defaults.merge config
    new_config = {}

    config.each{ |key, val| new_config[key.to_s.capitalize] = val }
    new_config
  end

  def vpn_defaults
    {:host => "localhost", :port => 1234, :timeout => 10}
  end
end
