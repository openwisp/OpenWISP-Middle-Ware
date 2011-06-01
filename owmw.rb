get '/access_points/:name/associated_users.xml' do
  @access_point = AccessPoint.find(params[:name])

  if @access_point
    @associated_users = []

    @access_point.associated_mac_addresses.each do |mac_address|
      @associated_users << AssociatedUser.find_by_mac_address(mac_address)
    end

    @associated_users.compact.to_xml
  else
    404
  end
end

get '/associated_users/:mac_address/access_point.xml' do
  vpn_server = OpenVpn.new(settings.vpns_to_scan)
  cn = vpn_server.find_client_cname_by_associated_mac_address(params[:mac_address])

  @access_point = AccessPoint.find(cn)

  if @access_point
    @access_point.to_xml
  else
    404
  end
end
