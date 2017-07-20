# frozen_string_literal: true

set :local_repo_root, File.expand_path('../../../repos', __FILE__)
set :local_repo_path, File.join(fetch(:local_repo_root), fetch(:application))

# We want to build this locally and push the built version to the server,
# se we need to redefine the SCM tasks

# rubocop:disable Metrics/BlockLength
namespace :git do
  # Clone the repo to the local directory if it is not yet cloned.
  Rake::Task['git:clone'].clear_actions
  task :clone do
    run_locally do
      `mkdir -p #{fetch(:local_repo_root).to_s}`
      Dir.chdir(fetch(:local_repo_root).to_s) do
        unless Dir.exist?(fetch(:local_repo_path))
          `git clone #{fetch(:repo_url)} #{fetch(:local_repo_path)}`
        end
      end
    end
  end

  # This shall fetch the remote repo to the local directory and update it to the
  # given branch/commit.
  Rake::Task['git:update'].clear_actions
  task :update do
    run_locally do
      Dir.chdir(fetch(:local_repo_path)) do
        `git remote update --prune`
      end
    end
  end

  # This shall only create the release directory, and not push the repository at
  # the given commit into it. Later on, the built app will be uploaded there.
  Rake::Task['git:create_release'].clear_actions
  task create_release: :'git:update' do
    on release_roles :all do
      with fetch(:git_environmental_variables) do
        within repo_path do
          execute :mkdir, '-p', release_path
        end
      end
    end
  end

  Rake::Task['git:set_current_revision'].clear_actions
  task :set_current_revision do
    run_locally do
      Dir.chdir(fetch(:local_repo_path)) do
        current_revision = `git rev-list --max-count=1 #{fetch(:branch)}`.strip
        set :current_revision, current_revision
      end
    end
  end
end

# This is needed because capistrano expects a repo directory to exist.
after :'deploy:check:directories', :create_repo_directory do
  on roles(:all) do
    execute('mkdir', '-p', repo_path)
  end
end

# Find the latest tag in the local repository
# (overwrite the task for the live stage)
Rake::Task['set_latest_tag'].clear_actions
after :'git:update', :set_latest_tag do
  run_locally do
    Dir.chdir(fetch(:local_repo_path)) do
      set :latest_tag, `git tag --list`.lines.last.strip
    end
  end
end
after :set_latest_tag, :set_deploy_tag

after :'git:update', :'git:checkout' do
  run_locally do
    Dir.chdir(fetch(:local_repo_path)) do
      ref = fetch(:branch)
      # We check out a tag in a live stage - no 'origin/' required
      if fetch(:stage).to_s.split('_', 2).first != 'live'
        ref = "origin/#{ref}" unless ref.start_with?('origin/')
      end
      # Clean and reset to allow a checkout
      `git clean -fd .`
      `git reset --hard`
      # Actuall checkout
      `git checkout #{ref}`
      # Clean again because the .gitignore might have changed and thus, the
      # previous cleaning might be inclomplete.
      `git clean -fd .`
    end
  end
end

# Deploy the application
desc 'deploy the application'
task :publish_built_application do
  on roles(:all) do
    remote_base_dir = fetch(:release_path).to_s
    local_base_dir = File.join(fetch(:local_repo_path), 'build')
    files = Dir.glob(File.join(local_base_dir, '**/*')).reject do |file|
      File.directory?(file)
    end
    files.each do |local_file|
      remote_file = local_file.to_s.sub(local_base_dir, remote_base_dir)
      remote_dir = File.dirname(remote_file).sub(%r{\A~/}, '')
      execute :mkdir, '-p', remote_dir
      upload! local_file, remote_dir
    end
  end
end
