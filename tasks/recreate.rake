# frozen_string_literal: true

namespace :db do
  desc 'Recreate the database'
  task :recreate do
    on roles(:all) do |host|
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute(:bundle, :exec, :rake, 'db:recreate')
        end
      end
    end
  end

  namespace :recreate do
    desc 'Recreate the database and seed it'
    task :seed do
      on roles(:all) do |host|
        within release_path do
          with rails_env: fetch(:rails_env) do
            execute(:bundle, :exec, :rake, 'db:recreate:seed')
          end
        end
      end
    end
  end
end
