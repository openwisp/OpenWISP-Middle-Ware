after 'deploy:update_code', 'deploy:symlink_settings'

namespace :deploy do
  desc "Symlinks the settings.rb"
  task :symlink_settings, :roles => :app do
    run "ln -nfs #{deploy_to}/shared/config/settings.rb #{release_path}/config/settings.rb"
  end
end
