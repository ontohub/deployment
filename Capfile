# frozen_string_literal: true

require 'pry'

# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'
require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile, but do this in the
# config/mixin/application/*.rb files. This way, for instance, npm recipies do
# not mess up a rails-only project.
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#   https://github.com/capistrano/npm
#   https://github.com/capistrano/bower
#   https://github.com/netguru/capistrano-ember_cli
#
# require 'capistrano/rvm'
# require 'capistrano/rbenv'
# require 'capistrano/chruby'
# require 'capistrano/bundler'
# require 'capistrano/rails/assets'
# require 'capistrano/rails/migrations'
# require 'capistrano/passenger'
# require 'capistrano/npm'
# require 'capistrano/bower'
# require 'capistrano/ember_cli'

# Add the mixin method
$:.unshift(File.dirname(__FILE__))
require 'lib/mixin'
require 'lib/popen'

# Disable freezing rake tasks
require 'lib/disable_immutable_task'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('tasks/*.rake').each { |r| import r }

set :migration_role, :app

# vim syntax=ruby
