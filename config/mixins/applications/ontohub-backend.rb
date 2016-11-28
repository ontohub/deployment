# frozen_string_literal: true

Rake::Task['load:defaults'].invoke
Rake::Task['load:defaults'].clear
require 'capistrano/rbenv'
require 'capistrano/bundler'
require 'capistrano/rails/migrations'
Rake::Task['load:defaults'].reenable
Rake::Task['load:defaults'].invoke

set :application, 'ontohub-backend'
set :repo_url, 'https://github.com/ontohub/ontohub-backend.git'

# Default value for :linked_files is []
append :linked_files, 'config/database.yml', 'config/secrets.yml',
                      'config/settings.local.yml'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'public/system', 'public/uploads',
                     'tmp/cache', 'tmp/pids', 'tmp/sockets',
                     'vendor/bundle'

set :rbenv_type, :system # or :user
# The ruby version is only considered if there is no override (like a
# .ruby-version file)
set :rbenv_ruby, '2.3.3'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} "\
                   "#{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby rails)

set :bundle_binstubs, -> { "~#{fetch(:deploy_user)}/bin" }

set :migration_role, :app

# OvGU related settings

after :'deploy:publishing', :create_symlinks do
  on roles(:all) do
    execute('ln', '-sf',
            File.join(fetch(:deploy_to), 'current'),
            "~#{fetch(:deploy_user)}/webapp")

    execute('ln', '-sf',
            File.join(fetch(:deploy_to), 'current'),
            File.join(fetch(:deploy_to), 'webapp'))
  end
end

before :'deploy:finished', :'puma:restart' do
  on roles(:all) do
    execute('/usr/sbin/svcadm', 'disable', '-s', 'puma',
            raise_on_non_zero_exit: false)
    execute('/usr/sbin/svcadm', 'enable', '-s', 'puma')
  end
end
