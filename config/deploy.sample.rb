set :application, "cafe"
set :repo_url, "git@github.com:jedaeroweb/cafe.git"
set :branch, 'master'
set :deploy_to, '/home/deploy/cafe'

# set :format, :pretty
# set :log_level, :debug
#set :pty, true
set :linked_files, %w{config/database.yml config/credentials/production.key .env}
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets public/assets public/uploads }

set :rbenv_type, :user
set :rbenv_ruby, "3.3.4"
set :ssh_options, verify_host_key: :never
set :default_env, {'NODE_OPTIONS'=>'--openssl-legacy-provider'}
set :bundle_path, '/usr/local/bundle'

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 3

namespace :rbenv do
  desc "Run rbenv rehash"
  task :rehash do
    on roles(:app) do
      execute "~/.rbenv/bin/rbenv", "rehash"
    end
  end
end

after 'bundler:install', 'rbenv:rehash'

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      within release_path do
        execute :rake, 'tmp:clear'
      end
    end
  end

  desc 'Refresh sitemap'
  task :refresh_sitemap do
    on roles(:app), in: :sequence, wait: 1 do
      within release_path do
        with rails_env: (fetch(:rails_env) || fetch(:stage)) do
          execute :rake, 'sitemap:refresh'
        end
      end
    end
  end

  after :finishing, 'deploy:refresh_sitemap'
  after :finishing, 'deploy:cleanup'
end
