# frozen_string_literal: true

# Machine configuration
set :deploy_user, 'webadm'
server 'staging.ontohub.org', user: fetch(:deploy_user), roles: %w(app db web)
set :tmp_dir, '/var/tmp'
set :rbenv_custom_path, '/local/usr/ruby'

set :branch, 'master'

# Frontend configuration
set :backend_url, 'https://tb.iks.cs.ovgu.de'
set :grecaptcha_site_key, '6LdKSR8UAAAAANuiYuJcuJRQm4Go-dQh0he82vpU'

# APIdoc configuration
set :apidoc_dir, 'staging'

# Local repository targets
after :'git:update', :set_latest_tag {}
after :set_latest_tag, :set_deploy_tag {}
