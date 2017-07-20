# frozen_string_literal: true

Rake::Task['load:defaults'].invoke
Rake::Task['load:defaults'].clear
mixin('ruby_project_requirements')
require 'capistrano/rails/migrations'
Rake::Task['load:defaults'].reenable
Rake::Task['load:defaults'].invoke

set :application, 'ontohub-backend'
set :repo_url, 'https://github.com/ontohub/ontohub-backend.git'

mixin('ruby_project_config')

# Default value for :linked_files is []
append :linked_files, 'config/database.yml',
                      'config/secrets.yml',
                      'config/settings.local.yml',
                      'config/settings/production.local.yml',
                      'config/environments/production.local.rb'

# Default value for linked_dirs is []
append :linked_dirs, 'log', 'public/system', 'public/uploads',
                     'tmp/cache', 'tmp/pids', 'tmp/sockets',
                     'vendor/bundle'

set :migration_role, :app

after :'deploy:updated', :'version:fetch' do
  on roles(:all) do
    within repo_path do
      with fetch(:git_environmental_variables) do
        set :backend_version, capture(:git, 'describe', '--tags', '--long')
      end
    end
  end
end

before :'deploy:published', :'version:write_to_file' do
  on roles(:all) do
    within release_path do
      execute(:echo, "\"#{fetch(:backend_version)}\" > VERSION")
    end
  end
end

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
