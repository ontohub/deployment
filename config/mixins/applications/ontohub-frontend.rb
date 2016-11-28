# frozen_string_literal: true

Rake::Task['load:defaults'].invoke
Rake::Task['load:defaults'].clear
require 'capistrano/yarn'
require 'capistrano/bower'
require 'capistrano/ember_cli'
Rake::Task['load:defaults'].reenable
Rake::Task['load:defaults'].invoke

set :application, 'ontohub-frontend'
set :repo_url, 'https://github.com/ontohub/ontohub-frontend.git'

# set :yarn_target_path, -> { release_path.join('node_modules') }
# default without `--production` (needed for building the ember app):
set :yarn_flags, ['--global-folder', File.join(fetch(:deploy_to), 'yarn'),
                  '--cache-folder', File.join(fetch(:deploy_to), 'yarn-cache'),
                  '--pure-lockfile',
                  '--no-emoji'].join(' ')
set :bower_bin, -> { release_path.join('node_modules/bower/bin/bower') }
set :bower_flags, '--production --quiet --config.interactive=false'
set :ember_cli_binary, -> { release_path.join('node_modules/.bin/ember') }
set :ember_cli_roles, :web
set :ember_cli_output_path, 'dist'
# set :ember_cli_target_path, nil # defaults to the release_path
set :ember_cli_env, :production

# Default value for :linked_files is []
append :linked_files, 'config/environment.js'

after :'deploy:publishing', :create_symlinks do
  on roles(:all) do
    execute('ln', '-sf',
            File.join(fetch(:deploy_to), 'current',
              fetch(:ember_cli_output_path)),
            File.join(fetch(:deploy_to), 'webapp'))

    execute('ln', '-sf',
            File.join(fetch(:deploy_to), 'current',
              fetch(:ember_cli_output_path)),
            File.join("~#{fetch(:deploy_user)}", 'public', 'html'))
  end
end
