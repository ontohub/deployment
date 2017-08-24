# frozen_string_literal: true

require 'graphql-docs'

Rake::Task['load:defaults'].invoke
Rake::Task['load:defaults'].clear
Rake::Task['load:defaults'].reenable
Rake::Task['load:defaults'].invoke

set :application, 'apidoc'
set :repo_url, 'https://github.com/ontohub/ontohub-backend.git'
set :deploy_base_dir, '/web/03_theo/sites/docs.ontohub.org/htdocs'
set :deploy_to, "#{fetch(:deploy_base_dir)}/#{fetch(:apidoc_dir)}"

mixin('local_repository')

# rubocop:disable Metrics/BlockLength
before :'deploy:publishing', :build_application do
  run_locally do
    release_dir = fetch(:release_path).sub(%r{\A#{fetch(:deploy_to)}/}, '')
    Bundler.with_clean_env do
      local_repo = fetch(:local_repo_path)
      build_dir = File.join(local_repo, 'build')
      Dir.chdir(local_repo) do
        # rubocop:enable Metrics/BlockLength
        system('bundle install')

        # Build the REST API documentation into a temp directory
        system('bundle exec rails apidoc:prepare')
        system('bundle exec rails apidoc:init')
        Dir.chdir('apidoc') do
          system('yarn build')
        end

        # Build the GraphQL documentation into a temp directory
        apidoc_graphql_dir = File.join(local_repo, 'apidoc-graphql')
        graphql_schema_file = File.join(local_repo, 'tmp/graphql_schema.json')

        popen({'FILE' => graphql_schema_file},
              'bundle', 'exec', 'rails', 'graphql:write_json')

        base_url = File.join('/', fetch(:apidoc_dir), release_dir, 'graphql')
        GraphQLDocs.build(delete_output: true,
                          output_dir: apidoc_graphql_dir,
                          base_url: base_url,
                          path: graphql_schema_file)

        # Move the generated documentation files to the `build` directory
        FileUtils.rm_rf(build_dir)
        system("mkdir -p #{build_dir}")
        FileUtils.mv(File.join(local_repo, 'apidoc/build'),
                     File.join(build_dir, 'rest'))
        FileUtils.mv(apidoc_graphql_dir, File.join(build_dir, 'graphql'))

        # Add an index page to select the API docs:
        index_content = <<~INDEX
          <html>
            <head>
              <title>Ontohub API Documentation</title>
            </head>
            <body>
              <h1>Ontohub API Documentation</h1>
              <p>Please select an API</p>
              <ul>
                <li><a href="graphql">GraphQL</a> (with full functionality)</li>
                <li><a href="rest">REST</a> (read only actions)</li>
              </ul>
            </body>
          </html>
        INDEX
        File.write(File.join(build_dir, 'index.html'), index_content)
      end
    end
  end
end

after :build_application, :publish_built_application

after :publish_built_application, :remove_unnecessary_directories do
  on roles(:all) do
    execute(:rmdir, File.join(fetch(:deploy_to), 'repo'))
    execute(:rmdir, File.join(fetch(:deploy_to), 'shared'))
  end
end
