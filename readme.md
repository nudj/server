# nudj http service

[![Codefresh build status]( https://g.codefresh.io/api/badges/build?repoOwner=nudj&repoName=service&branch=master&pipelineName=master&accountName=collingo&key=eyJhbGciOiJIUzI1NiJ9.NThhZDVhYzdhOGU4YWUwMTAwMzQ4MTcz.LswrznCGW0BHHD1jCDCg-EWQm_-4_j0qwWCvUTZcCYA&type=cf-1)]( https://g.codefresh.io/repositories/nudj/service/builds?filter=trigger:build;branch:master;service:58b58053d34d0c0100e573d1~master)

HTTP layer covering of all the nudj microservices

NB all instances of `[environment]` should be replaced by the environment in question - `staging`, `demo` or `production`

# Intro

This has been broken down into folders holding configurations for each environment. In terms of directory structure they should look something like the following...

- [environment]
  - **ssl**
    - **ca_bundle.crt**
    - **certificate.crt**
    - **private.key**
  - .dockerignore
  - **.env-admin**
  - **.env-api**
  - **.env-db**
  - **.env-hire**
  - **.env-web**
  - **.htpasswd**
  - docker-compose.yml
  - Dockerfile
  - gzip.conf
  - service.conf

The files/dirs in **bold** are gitignored and so should be copied from a colleague or 1Password.

# End-to-end development

Allows for end to end testing of all the apps together. Emulates the live environment with rebuilding on file change.

1. Ensure `/etc/hosts` on your host machine has the following entries
  ```
  127.0.0.1 local.nudj.co
  127.0.0.1 local.hire.nudj.co
  127.0.0.1 local.admin.nudj.co
  127.0.0.1 local.api.nudj.co
  127.0.0.1 local.gql.nudj.co
  127.0.0.1 local.db.nudj.co
  ```
1. Ensure you have run `make build` inside `server`, `web`, `hire`, `admin` and `api`
1. Ensure you have all the required `.env` files, `.htpasswd` file and ssl cert files in the `./local` dir (ask for them from a colleague)
1. From the project root run `make up` to start the platform in develop mode
1. On first run...
  1. Copy the generated Arango root password from the logs in the console
  1. Go to `https://local.db.nudj.co/`
  1. Log in with u: root and the copied password
  1. Create a new database with name `nudj`
  1. Create a new user with name `nudjtech`
  1. Edit the new users permissions by checking read/write against the `nudj` database
  1. Create all the required collections (see the dev/staging db for reference or ask a colleague)
1. Wait until everything has built then access the sites on the `local.` domains
1. On first run...
  1. You will need to add data to the db in order for the apps to work. Ask a colleague to show you what minimum data this is in order to get various pages working :)
1. Saving files in any of the applications will trigger a rebuild of that app
1. `ctrl-c` to quit the logs and return to command line (platform remains running headlessly in the background)
1. `make up` at any time to force recreate the platform (useful for environment changes)
1. `make down` to close down the platform and free up resources

# Full production emulation

Emulates the live environment without rebuilding on file change.

1. Ensure `/etc/hosts` is configured as above
1. Ensure you have run `make buildLocal` inside `server`, `web`, `hire`, `admin` and `api`
1. Ensure you have all the required `.env` files, `.htpasswd` file and ssl cert files in the `./local` dir (ask for them from a colleague)
1. `cd local`
1. Access the sites on the `local.` domains
1. `make up` to run the platform
1. `ctrl-c` to quit the logs and return to command line (platform remains running headlessly in the background)
1. `make up` at any time to force recreate the platform (useful for environment changes)
1. `make down` to close down the platform and free up resources

# Backups

1. Ensure you have ssh access to the relevant server (try running `ssh nudj[environment]` in the terminal). Ignore this step for local env
1. `yarn`
1. Ensure you have a `.env-api` file inside each environment dir you want to back up
1. `make backup ENV=[environment]` e.g. `make backup ENV=staging`
1. Enter `nudjtech` password for environment (can be found in 1Password) if requested
1. Backup will be found in the directory reported in the logs

# Restores

**DANGEROUS!!! Restoring completely replaces a DB with new data. Please use with caution!**

**Always backup first - see above**

**If in any doubt, do not use!!!**

1. Ensure you have ssh access to the relevant server (try running `ssh nudj[environment]` in the terminal). Ignore this step for local env
1. `yarn`
1. Ensure you have a `.env-api` file inside each environment dir you want to restore
1. `make restore ENV=[environment] INPUT_DIR=[inputDir]` e.g. `make restore ENV=local INPUT_DIR=/Users/nick/dev/nudj/local/dbdump`
  1. `INPUT_DIR` must be an absolute path to a db backup directory produced by the backup command above
1. Enter `nudjtech` password for environment (can be found in 1Password) if requested

# Releases

## staging or demo

Releases the most recent build image tagged with `latest` for each app to the specified environment. Check CI on the `develop` branches to track the image building progress and double check what you are deploying.

1. Ensure you have ssh access to the relevant server (try running `ssh nudj[environment]` in the terminal)
1. Ensure you have all the required `.env` files, `.htpasswd` file and ssl cert files in the environment dir you wish to release (ask for them from a colleague)
1. Ensure the builds on the develop branch for all applications have completed without error on CodeFresh
1. `make release ENV=[environment]` e.g. `make release ENV=staging`
1. Enter `nudjtech` password for environment (can be found in 1Password) when requested

## production

**DANGEROUS!!! Updates the production environment code. Please use with caution!**

**Always backup first - see above**

**If in any doubt, do not use!!!**

1. Ensure you have ssh access to the production server (try running `ssh nudjproduction` in the terminal)
1. Release all applications with their own semver versions and ensure the builds have completed and released the appropriately tagged Docker images
1. Ensure you have all the required `.env` files, `.htpasswd` file and ssl cert files in the production dir (ask for them from a colleague)
1. `make release ENV=production SERVER=[server-version] WEB=[web-version] HIRE=[hire-version] ADMIN=[admin-version] API=[api-version]` e.g. `make release ENV=production SERVER=1.0.0 WEB=2.0.0 HIRE=3.0.0 ADMIN=4.0.0 API=5.0.0`
1. Enter `nudjtech` password for production (can be found in 1Password) when requested

# Debugging environments

1. If you have ssh access, you can run `ssh nudj[environment]` to access the environment logs.
1. Once inside the container, run `cd [environment]`. e.g. `cd staging`
1. To get an overview of the docker images' processes, run `sudo docker-compose ps`
1. Enter `nudjtech` password for the given environment (can be found in 1Password) when prompted
1. If any of the images have gone down or failed, try attempting a re-release.
1. To debug a specific issue with an image, run `sudo docker-compose logs [repo]`
  - e.g. If you got an error on hitting the homepage for `dev.hire.nudj.co`, you might run `sudo docker-compose logs hire` to diagnose the issue.
1. To diagnose or debug issues further, see: **Full production emulation**

# Useful notes

## Logging into local db to run commands using the Arango CLI

1. Ensure you have run `make buildLocal` inside `web`, `hire`, `admin` and `api`
1. `cd ./local`
1. `make up` to get the apps spun up
1. `dco exec db /bin/sh` to open a shell inside the db container
1. `arangosh --server.database nudj --server.username nudjtech` to run the CLI
1. Enter password as you setup (if you were sensible you stored this in 1Password 😉)
1. Run arangosh commands as per [the docs](https://docs.arangodb.com/2.8/Arangosh/)
