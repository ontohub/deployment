# frozen_string_literal: true

set :deploy_user, 'webadm'
server 'staging.ontohub.org', user: fetch(:deploy_user), roles: %w(app db web)
set :tmp_dir, '/var/tmp'
set :rbenv_custom_path, '/local/usr/ruby'

# The branch will be set in the :set_deploy_tag task
set :branch, nil

# Find the latest tag in the repository
after :'git:update', :set_latest_tag do
  on roles(:all) do
    within repo_path do
      with fetch(:git_environmental_variables) do
        set :latest_tag, capture(:git, 'tag', '--list').lines.last.strip
      end
    end
  end
end

# Set the tag to deploy (sets the branch)
after :set_latest_tag, :set_deploy_tag do
  # Get the latest tags and set the default
  default_tag = fetch(:latest_tag)

  # Allow the developer to choose a tag to deploy
  # rubocop:disable Layout/SpaceInsideStringInterpolation
  set(:tag,
      ask("a tag to deploy: [Default: #{ default_tag }] ", default_tag))
  # rubocop:enable Layout/SpaceInsideStringInterpolation

  # Be extra cautious and exit if a tag cannot be found
  if fetch(:tag).nil? || fetch(:tag).empty?
    $stderr.puts 'Cannot deploy: The tag was not found.'
    exit
  end

  set(:branch, fetch(:tag))
end
