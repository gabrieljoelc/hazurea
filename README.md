# Hazurea

This follows the [Hasura](https://hasura.io/) [tutorial](https://hasura.io/docs/latest/graphql/core/deployment/deployment-guides/azure-container-instances-postgres.html) for deploying to Azure.

Hasura is an open source GraphQL engine built on PostgreSQL (although they are starting to support [more than just PostgreSQL](https://hasura.io/graphql/database/sql-server/)). It has super easy to use toolchain in it's web console and CLI. It also has robust but easy to use [authentication](https://hasura.io/docs/latest/graphql/core/auth/authentication/index.html) (including [JWT](https://hasura.io/docs/latest/graphql/core/auth/authentication/jwt.html) support) and [access control](https://hasura.io/docs/latest/graphql/core/auth/authorization/index.html) features.

# Local Development

Prerequisites:

- [Docker](https://docs.docker.com/install/)
- [Docker Compose](https://docs.docker.com/compose/install/)
- [Hasura CLI](https://docs.hasura.io/1.0/graphql/manual/hasura-cli/install-hasura-cli.html#install-hasura-cli)

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

# Remote schemas

I followed the steps in the Hasura Remote Schema [docs](https://docs.hasura.io/1.0/graphql/manual/remote-schemas/index.html) and the Node boilerplate [example](https://github.com/hasura/graphql-engine/tree/master/community/boilerplates/remote-schemas/aws-lambda/nodejs). Here are the steps I took:

TODO
