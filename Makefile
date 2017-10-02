IMAGE:=nudj/server

CWD=$(shell pwd)

.PHONY: build up down dumpDevelopment dumpStaging dumpProduction releaseDevelopment releaseStaging

build:
	@docker build -t $(IMAGE):local local

up:
	@cd local && \
		docker-compose -f $(CWD)/local/docker-compose-dev.yml up -d --force-recreate && \
		docker-compose -f $(CWD)/local/docker-compose-dev.yml logs -f

down:
	@cd local && \
		docker-compose -f $(CWD)/local/docker-compose-dev.yml down

dumpDevelopment:
	./dump

dumpStaging:
	./dump staging

dumpProduction:
	./dump production

releaseDevelopment:
	./release

releaseStaging:
	./release staging
