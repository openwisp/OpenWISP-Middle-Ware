### Helper Methods ###

helpers do
  def vpns_clients
    settings.vpns_to_scan.map{ |vpn| vpn_clients_of vpn }.flatten(1)
  end

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


### HTTP Resources ###

get '/access_points/:id/online_users.xml' do
  @access_point = AccessPoint.find(params[:id])

  if @access_point
    online = []
    on_radius = OnlineUser.all

    @access_point.l2vpn_clients.each do |l2vpn|
      on_access_point = vpns_clients.select{ |client| client[1] == l2vpn.identifier }

      on_radius.each do |user|
        if on_access_point.any?{ |client| client[0] == user.radius_accounting.calling_station_id }
          online << user
        end
      end
    end

    online.to_xml
  else
    404
  end
end
