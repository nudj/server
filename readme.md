# nudj http server

[![Codefresh build status]( https://g.codefresh.io/api/badges/build?repoOwner=nudj&repoName=server&branch=master&pipelineName=server&accountName=collingo&key=eyJhbGciOiJIUzI1NiJ9.NThhZDVhYzdhOGU4YWUwMTAwMzQ4MTcz.LswrznCGW0BHHD1jCDCg-EWQm_-4_j0qwWCvUTZcCYA&type=cf-1)]( https://g.codefresh.io/repositories/nudj/server/builds?filter=trigger:build;branch:master;service:58cbf6cb6f55780100ec571b~server)

HTTP layer covering of all the nudj microservices

# Setup

1. Get certificate and private key from colleague and drop into `/ssl`

# Development

1. Make changes to `service-dev.conf` and `docker-compose-dev.yml`
1. `make run`
1. Test everything works
1. Once happy, replicate changes into `service.conf` and `docker-compose.yml`

# Deploy

## Hyper.sh

1. Update `Makefile` with service version, deploy colour and microservice links
1. `hyper ps` to ensure all microservices to link in are running (currently only `web`)
1. `make build`
1. `make push`
1. `make deploy`
