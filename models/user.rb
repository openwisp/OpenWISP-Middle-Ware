class User < ActiveResource::Base
  extend ActiveModel::Naming
  include ActiveModel::Serializers::Xml

  self.site = settings.owums_base_site
  self.user = settings.owums_operator
  self.password = settings.owums_password
end
