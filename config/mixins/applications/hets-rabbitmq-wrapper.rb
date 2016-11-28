# frozen_string_literal: true

Rake::Task['load:defaults'].invoke
Rake::Task['load:defaults'].clear
require 'capistrano/rbenv'
require 'capistrano/bundler'
Rake::Task['load:defaults'].reenable
Rake::Task['load:defaults'].invoke

set :application, 'hets-rabbitmq-wrapper'
set :repo_url, 'https://github.com/ontohub/hets-rabbitmq-wrapper.git'

# Default value for :linked_files is []
# append :linked_files, 'config/settings.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log'

set :rbenv_type, :system # or :user
set :rbenv_ruby, File.read('.ruby-version').strip
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} "\
                   "RBENV_VERSION=#{fetch(:rbenv_ruby)} "\
                   "#{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w(rake gem bundle ruby)

set :bundle_binstubs, -> { shared_path.join('bin') }
