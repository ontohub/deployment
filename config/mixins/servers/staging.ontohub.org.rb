# frozen_string_literal: true

set :deploy_user, 'webadm'
server 'staging.ontohub.org', user: fetch(:deploy_user), roles: %w(app db web)
set :tmp_dir, '/var/tmp'
set :rbenv_custom_path, '/local/usr/ruby'

set :branch, 'master'
set :backend_url, 'https://tb.iks.cs.ovgu.de'
