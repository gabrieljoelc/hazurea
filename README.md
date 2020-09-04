# Hazurea

This shows how to use Hasura in Azure

# Local Development

Prerequisites:

- [Docker](https://docs.docker.com/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Hasura CLI](https://docs.hasura.io/1.0/graphql/manual/hasura-cli/install-hasura-cli.html#install-hasura-cli)

## Updates

The version of hasura is only updated on deploys.

If you need to update the version deploy a meaningless commit like the one that updated this Readme :)

## Getting started

Copy and set configuration for both Docker Compose and for Hasura commands:
```
cp .env.dist .env
# Replace admin secret for relevant environment
cp config.yaml.dist config.yaml
# Modify database URL in `config.yaml` if desired
```
Then run the following commands (see this [SO](https://stackoverflow.com/a/20909045/34315) for the `env $(cat...` stuff below):
```
docker-compose up -d # starts Postgres and Hasura engine locally
env $(cat .env | xargs) hasura migrate apply # to apply our existing migrations to the local db
env $(cat .env | xargs) hasura console # to start the web console for making changes to the database
```

Migrations are [automatically created](https://docs.hasura.io/1.0/graphql/manual/migrations/existing-database.html#step-5-add-a-new-table-and-see-how-a-migration-is-added) via the Hasura console.

Note: please do not use `--admin-secret` switch because the secret then could be stored in your shell history. Also, please do not use `admin_secret` property in the `config.yaml` so we don't accidentally check in secrets.

# Getting Started Terraform

## Prerequisites:

1. Install terraform 0.13
1. Install the Azure CLI

## Running Terraform:

From the `/devops` directory run:
1. If this is your first time running or a module has been updated run `terraform init`

# Misc

## Remote schema hello world

I followed the steps in the Hasura Remote Schema [docs](https://docs.hasura.io/1.0/graphql/manual/remote-schemas/index.html) and the Node boilerplate [example](https://github.com/hasura/graphql-engine/tree/master/community/boilerplates/remote-schemas/aws-lambda/nodejs). Here are the steps I took:

TODO
