# nudj http server

[![Codefresh build status]( https://g.codefresh.io/api/badges/build?repoOwner=nudj&repoName=server&branch=master&pipelineName=server&accountName=collingo&key=eyJhbGciOiJIUzI1NiJ9.NThhZDVhYzdhOGU4YWUwMTAwMzQ4MTcz.LswrznCGW0BHHD1jCDCg-EWQm_-4_j0qwWCvUTZcCYA&type=cf-1)]( https://g.codefresh.io/repositories/nudj/server/builds?filter=trigger:build;branch:master;service:58cbf6cb6f55780100ec571b~server)

HTTP layer covering of all the nudj microservices

# Intro

Since version 0.2.0 we are assuming the server will be run behind an AWS Elastic Load Balancer (ELB). Since the ELB will take care of SSL decoding this microservice will always receive requests over http. To ensure a redirect of HTTP -> HTTPS we need to check the `X-Forwarded-Proto` header that the ELB sends to us. See `service.conf` for the implementation.

# Development

1. Make changes to `service-dev.conf` and `docker-compose-dev.yml`
1. `make run`
1. Test everything works in Postman where you can add the `X-Forwarded-Proto` header
1. Once happy, replicate changes into `service.conf` and `docker-compose.yml`
