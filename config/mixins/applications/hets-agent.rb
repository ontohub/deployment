# frozen_string_literal: true

Rake::Task['load:defaults'].invoke
Rake::Task['load:defaults'].clear
mixin('ruby_project_requirements')
Rake::Task['load:defaults'].reenable
Rake::Task['load:defaults'].invoke

set :application, 'hets-agent'
set :repo_url, 'https://github.com/ontohub/hets-agent.git'

mixin('ruby_project_config')

# Default value for :linked_files is []
append :linked_files, 'config/database.yml',
                      'config/settings.local.yml',
                      'config/settings/production.local.yml'

# Default value for linked_dirs is []
# append :linked_dirs, 'log'
