IMAGE:=nudj/server

CWD=$(shell pwd)

.PHONY: build up down backupDevelopment backupStaging backupProduction releaseDevelopment releaseStaging

build:
	@docker build -t $(IMAGE):local local

up:
	@cd local && \
		docker-compose -f $(CWD)/local/docker-compose-dev.yml up -d --force-recreate && \
		docker-compose -f $(CWD)/local/docker-compose-dev.yml logs -f

down:
	@cd local && \
		docker-compose -f $(CWD)/local/docker-compose-dev.yml down

backupDevelopment:
	./scripts/backup

backupStaging:
	./scripts/backup staging

backupProduction:
	./scripts/backup production

releaseDevelopment:
	./scripts/release

releaseStaging:
	./scripts/release staging
