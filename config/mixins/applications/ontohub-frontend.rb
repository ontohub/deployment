# frozen_string_literal: true

Rake::Task['load:defaults'].invoke
Rake::Task['load:defaults'].clear
Rake::Task['load:defaults'].reenable
Rake::Task['load:defaults'].invoke

set :application, 'ontohub-frontend'
set :repo_url, 'https://github.com/ontohub/ontohub-frontend.git'

mixin('local_repository')

before :'deploy:publishing', :build_application do
  run_locally do
    Dir.chdir(fetch(:local_repo_path)) do
      # Build the application and print the result
      system('yarn')

      env = {'REACT_APP_BACKEND_HOST' => fetch(:backend_url),
             'REACT_APP_GRECAPTCHA_SITE_KEY' => fetch(:grecaptcha_site_key)}
      popen(env, 'yarn', 'build')
    end
  end
end

after :build_application, :publish_built_application

after :'deploy:publishing', :create_symlinks do
  on roles(:all) do
    execute('ln', '-sf',
            File.join(fetch(:deploy_to), 'current'),
            File.join(fetch(:deploy_to), 'webapp'))

    execute('ln', '-sf',
            File.join(fetch(:deploy_to), 'current'),
            File.join("~#{fetch(:deploy_user)}", 'public', 'html'))
  end
end
