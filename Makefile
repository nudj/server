IMAGE:=nudj/server
IMAGEUI:=nudj/test-ui
COREAPPS:=server redis db
DOCKERCOMPOSE:=docker-compose -p nudj
CWD=$(shell pwd)
SYNC ?= false

.PHONY: build up down backup restore release

build:
	@docker build -t $(IMAGE):development local
	@docker build -t $(IMAGEUI) test/ui

up:
	@$(DOCKERCOMPOSE) up -d --force-recreate --no-deps $(COREAPPS)

logs:
	@$(DOCKERCOMPOSE) logs -f $(COREAPPS)

down:
	@$(DOCKERCOMPOSE) rm -f -s $(COREAPPS)

backup:
	@env -i $$(node ./scripts/extract-envkeys.js $(ENV) DB_USER DB_PASS) ./scripts/backup $(ENV)

restore:
	@env -i $$(node ./scripts/extract-envkeys.js $(ENV) DB_USER DB_PASS) ./scripts/restore $(ENV) $(INPUT_DIR)

release:
	@env -i $$(node ./scripts/extract-envkeys.js $(ENV) DB_USER DB_PASS) ./scripts/release $(ENV) $(SYNC) $(SERVER) $(WEB) $(HIRE) $(ADMIN) $(API)

migrate:
	@env -i $$(node ./scripts/extract-envkeys.js $(ENV) DB_USER DB_PASS) ./scripts/migrate $(ENV) $(MIGRATION) $(DIRECTION)
