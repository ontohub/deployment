# Deployment configuration

This repository holds the deployment configuration for the multiple Ontohub components.
For each of the component and each server that a component should be deployed to, there is a deployment-stage,
i.e. a mix of configurations that allow easy deployment with capistrano.

## How to deploy

The basic command to deploy `<application>` in the `<environment>` to a `<server>` is

    $ bundle exec cap <server>_<application> deploy

where the three place holders can be:
* `<server>` is one of
  * `staging` (staging.ontohub.org)
* `<application>` is one of
  * `ontohub-frontend`
  * `ontohub-backend`
  * `hets-rabbitmq-wrapper`

so to deploy the backend to staging.ontohub.org, you need to execute

    $ bundle exec cap staging_ontohub-backend deploy

## First deployment

Before the first deployment can succeed, the files and directories that are targets of symbolic links must be created on the server.
Which files and directories are needed to be created is specified in the `:linked_files` and `:linked_dirs` configuration variables of the corresponding application config file in [config/mixins/applications](config/mixins/applications).
These files and directories must be located at `:deploy_to/shared/`.

## Required tools and libs
### ontohub-backend
#### On the deploying machine
* bundler
#### On the server
* rbenv
* bundler

### ontohub-frontend
The ontohub-frontend repository is fetched to the machine that invokes capistrano and built there.
The result (static html/css/js) is then uploaded to the server.
Therefore, we need to install all dependencies of the ontohub-frontend on the deploying machine and nothing at all on the server.
#### On the deploying machine
* yarn
#### On the server
* nothing at all

## Structure

Each allowed deployment stage is set up in [config/deploy](config/deploy) and basically consists of mixins from [config/mixins/applications](config/mixins/applications), [config/mixins/environments](config/mixins/environments) and [config/mixins/servers](config/mixins/servers).

The environments must only set what is needed for the runtime environment (e.g. production, development, test) of the applications.

The servers must only set what is needed for a specific deployment server (e.g. ta, tb, tc, etc.).

The applications must set everything needed for the application itself.
These configurations can be aware of the provisioning of a server (e.g. where ruby is found and how to start/stop services).

## Thanks

The structure of this deployment configuration repository is based on the articles "Deploying Multiple Applications with Capistrano from a Single Project" at Packt [[1]](https://www.packtpub.com/books/content/part-1-deploying-multiple-applications-capistrano-single-project) [[2]](https://www.packtpub.com/books/content/part-2-deploying-multiple-applications-capistrano-single-project).
