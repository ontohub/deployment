# frozen_string_literal: true

Rake::Task['deploy:symlink:release'].clear_actions

namespace :deploy do
  namespace :symlink do
    desc 'Symlink release to current'
    # This overwrites the default capistrano task to create a relative symlink.
    task :release do
      on release_roles :all do
        within deploy_path do
          current = current_path.sub(%r{\A#{deploy_path}/?}, '')
          release = release_path.sub(%r{\A#{deploy_path}/?}, '')
          execute :ln, '-sf', release, current
        end
      end
    end
  end
end
