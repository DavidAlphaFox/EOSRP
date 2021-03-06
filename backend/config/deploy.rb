# config valid only for Capistrano 3.1
require 'rvm1/capistrano3'
#require 'whenever/capistrano'

lock '3.4.1'

set :application, 'eosrp_backend'
set :repo_url, 'http://github.com/eosystems/eosrp.git'

# subdirectory release
set :git_strategy, Capistrano::Git::MultiSubDirectoryStrategy
set :deploy_sub_dirs, ["backend"] # backendだけデプロイする
set :bundle_gemfile, "backend/Gemfile"
set :rails_root, 'backend'
set :unicorn_config_path, "config/unicorn.rb"

# git clone の際にローカルの秘密鍵を使用する
# set :ssh_options, { forward_agent: true }

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/var/www/eosrp_backend'

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Shared
set :linked_files, fetch(:linked_files, []).push('backend/config/database.yml','backend/config/secrets.yml','backend/config/settings.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('backend/log','backend/tmp/pids','backend/tmp/cache','backend/tmp/sockets','backend/vendor/bundle','backend/public/system')
#set :linked_files, %w{config/database.yml config/secrets.yml config/settings.yml}
#set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# RVM
set :rvm_type, :system
set :rvm1_ruby_version, '2.2.3'

# Unicorn
set :unicorn_pid, "#{shared_path}/backend/tmp/pids/unicorn_eosrp.pid"

# Whenever
#set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app) do
      invoke 'unicorn:restart'
    end
  end

  desc 'upload importabt files'
  task :upload do
    on roles(:app) do |host|
      if test "[ ! -d #{shared_path}/backend/config ]"
        execute :mkdir, '-p', "#{shared_path}/backend/config"
      end
      upload!('config/database.yml',"#{shared_path}/backend/config/database.yml")
      upload!('config/secrets.yml',"#{shared_path}/backend/config/secrets.yml")
      upload!('config/settings.yml',"#{shared_path}/backend/config/settings.yml")
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end

  #before :started, 'deploy:upload'
  after :finishing, 'deploy:cleanup'
end
