# frozen_string_literal: true

namespace :deploy do
  desc 'Initially create directories for the application on the remote server.'\
    '(Needs to be executed only once).'
  task :initially_create_directories do
    on roles(:all) do |host|
      deploy_basedir = File.dirname(fetch(:deploy_to))
      if test("[ ! -w #{deploy_basedir} ]")
        error %(The base directory for the deployment "#{deploy_basedir}" )\
          "is not writable on #{host}."
      else
        %w(shared).each do |subdir|
          dir = File.join(fetch(:deploy_to), subdir)
          if test("[ ! -d #{dir} ]")
            execute(:mkdir, '-p', dir)
            info %(Created directory "#{dir}" on #{host})
          end
        end
      end
    end
  end
end
