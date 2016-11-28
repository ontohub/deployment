# frozen_string_literal: true

desc 'Check that we can access everything'
task :check_write_permissions do
  on roles(:all) do |host|
    deploy_basedir = File.dirname(fetch(:deploy_to))
    if test("[ -w #{deploy_basedir} ]")
      info %(The base directory for the deployment "#{deploy_basedir}" )\
           "is writable on #{host}."
    else
      error %(The base directory for the deployment "#{deploy_basedir}" )\
            "is not writable on #{host}."
    end
  end
end
