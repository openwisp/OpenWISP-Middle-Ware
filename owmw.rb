get '/access_points/:id/online_users.xml' do
  @access_point = AccessPoint.find(params[:id])

  if @access_point
    @online_users = []

    @access_point.associated_mac_addresses.each do |mac_address|
      @online_users << OnlineUser.find_by_mac_address(mac_address)
    end

    @online_users.compact.to_xml
  else
    404
  end
end

get '/online_users/:mac_address/access_point.xml' do
  vpn_server = OpenVpn.new(settings.vpns_to_scan)
  cn = vpn_server.find_client_cname_by_associated_mac_address(params[:mac_address])

  @access_point = AccessPoint.find(cn)

  if @access_point
    @access_point.to_xml
  else
    404
  end
end
