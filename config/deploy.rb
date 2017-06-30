# frozen_string_literal: true

# config valid only for current version of Capistrano
lock '3.8.2'

# See configuration manual for options
#   http://capistranorb.com/documentation/getting-started/configuration

set :deploy_to, -> { "~/#{fetch(:application)}" }
set :keep_releases, 5

# Overwrite the branch in the stage config
set :branch, 'master'
# Or use the current branch with
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true,
#                      log_file: 'log/capistrano.log',
#                      color: :auto,
#                      truncate: :auto

# Default value for :pty is false
# set :pty, true
