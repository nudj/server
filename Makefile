IMAGE:=nudj/server
IMAGEUI:=nudj/test-ui

CWD=$(shell pwd)

.PHONY: build up down backup restore release

build:
	@docker build -t $(IMAGE):local local
	@docker build -t $(IMAGEUI) test/ui

up:
	@cd local && \
		docker-compose -f $(CWD)/local/docker-compose-dev.yml up -d --force-recreate && \
		docker-compose -f $(CWD)/local/docker-compose-dev.yml logs -f

down:
	@cd local && \
		docker-compose -f $(CWD)/local/docker-compose-dev.yml down

backup:
	@env -i $$(node ./scripts/extract-envkeys.js $(ENV) DB_USER DB_PASS) ./scripts/backup $(ENV)

restore:
	@env -i $$(node ./scripts/extract-envkeys.js $(ENV) DB_USER DB_PASS) ./scripts/restore $(ENV) $(INPUT_DIR)

release:
	@env -i $$(node ./scripts/extract-envkeys.js $(ENV) DB_USER DB_PASS) ./scripts/release $(ENV) $(SERVER) $(WEB) $(HIRE) $(ADMIN) $(API)

migrate:
	@env -i $$(node ./scripts/extract-envkeys.js $(ENV) DB_USER DB_PASS) ./scripts/migrate $(ENV) $(MIGRATION) $(DIRECTION)
