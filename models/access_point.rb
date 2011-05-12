class AccessPoint < ActiveResource::Base
  extend ActiveModel::Naming
  include ActiveModel::Serializers::Xml

  self.site = settings.owm_base_site
  self.user = settings.owm_operator
  self.password = settings.owm_password
end
