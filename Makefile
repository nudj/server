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
	@env -i $$(node ./scripts/extract-envkeys.js development DB_USER DB_PASS) ./scripts/backup development

backupStaging:
	@env -i $$(node ./scripts/extract-envkeys.js staging DB_USER DB_PASS) ./scripts/backup staging

backupProduction:
	@env -i $$(node ./scripts/extract-envkeys.js production DB_USER DB_PASS) ./scripts/backup production

releaseDevelopment:
	./scripts/release

releaseStaging:
	./scripts/release staging 2.1.0 6.1.0 LEGACY-V1 LEGACY-V1 LEGACY-V1
