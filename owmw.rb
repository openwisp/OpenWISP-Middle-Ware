### Helper Methods ###

helpers do
  def vpns_clients
    settings.vpns_to_scan.map{ |vpn| vpn_clients_of vpn }
  end

  def vpn_clients_of(config)
    current = OpenVPNServer.new vpn_config(config)
    clients = current.status.last
    current.close

    clients
  end

  def vpn_config(config)
    new_config = {}
    new_config.each{ |key, val| config[key.to_s.capitalize] = val }

    vpn_defaults.merge new_config
  end

  def vpn_defaults
    {:host => "localhost", :port => 1234, :timeout => 10}
  end
end


### HTTP Resources ###

get '/clients_connected_to/:access_point' do
  @access_point = AccessPoint.find(:first, :params => {:name => params[:access_point]})

  if @access_point
    @access_point.l2vpn_clients.each do |l2vpn|
      online = []

      on_radius = OnlineUser.all
      on_access_point = vpns_clients.select{ |client| client[1] == l2vpn.identifier }

      on_radius.each do |user|
        if on_access_point.any?{ |client| client[0] == user.radius_accounting.calling_station_id }
          online << user
        end
      end
    end

    user.to_xml
  else
    404
  end
end
