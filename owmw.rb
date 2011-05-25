get '/access_points/:id/online_users.xml' do
  @access_point = AccessPoint.find(params[:id])

  if @access_point
    online = []
    on_radius = OnlineUser.all

    @access_point.l2vpn_clients.each do |l2vpn|
      on_access_point = OpenVpn.new(settings.vpns_to_scan).select{ |client| client[1] == l2vpn.identifier }

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
