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

#get '/access_points/:mac_address/urls.xml' do
#end
