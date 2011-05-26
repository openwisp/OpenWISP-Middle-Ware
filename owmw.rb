get '/access_points/:id/online_users.xml' do
  @access_point = AccessPoint.find(params[:id])

  if @access_point
    online = []
    on_radius = OnlineUser.all

    @access_point.l2vpn_clients.each do |l2vpn|
      vpns = OpenVpn.new(settings.vpns_to_scan)
      connected_to_ap = vpns.find_users_by_cname(l2vpn.identifier)

      on_radius.each do |user|
        if connected_to_ap.any?{ |client| client == user.radius_accounting.calling_station_id }
          online << user
        end
      end
    end

    online.to_xml
  else
    404
  end
end
