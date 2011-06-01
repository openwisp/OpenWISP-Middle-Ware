get '/access_points/:name/associated_users.xml' do
  @access_point = AccessPoint.find(params[:name])

  if @access_point
    @associated_users = []

    @access_point.associated_mac_addresses.each do |mac_address|
      @associated_users << OnlineUser.find_by_mac_address(mac_address)
    end

    @associated_users.compact.to_xml
  else
    404
  end
end

get '/associated_users/:mac_address.xml' do
  vpn_server = OpenVpn.new(settings.vpns_to_scan)
  cn = vpn_server.find_client_cname_by_associated_mac_address(params[:mac_address])

  @associated_user = AssociatedUser.new.load(
    :access_point => AccessPoint.find(cn)
  )

  if @associated_user
    @associated_user.to_xml
  else
    404
  end
end
