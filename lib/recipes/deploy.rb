# This file is part of the OpenWISP MiddleWare
#
# Copyright (C) 2011 CASPUR (wifi@caspur.it)
#
# This software is licensed under a Creative  Commons Attribution-NonCommercial
# 3.0 Unported License.
#   http://creativecommons.org/licenses/by-nc/3.0/
#
# Please refer to the  README.license  or contact the copyright holder (CASPUR)
# for licensing details.
#

after 'deploy:update_code', 'deploy:symlink_settings'

namespace :deploy do
  desc "Symlinks the settings.rb"
  task :symlink_settings, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/settings.rb #{release_path}/config/settings.rb"
  end
end
