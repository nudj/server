# nudj http service

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
