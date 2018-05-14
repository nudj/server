IMAGE:=nudj/server
IMAGEUI:=nudj/test-ui
COREAPPS:=server redis db sql
DOCKERCOMPOSE:=docker-compose -p nudj
CWD=$(shell pwd)
SYNC ?= false

.PHONY: build up down backup restore deploy

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
	@./devops/backup $(ENV)

restore:
	@./devops/restore $(ENV) $(INPUT_DIR)

deploy:
	@./devops/deploy $(ENV) $(SYNC) $(SERVER) $(WEB) $(HIRE) $(ADMIN) $(API)

migrate:
	@./devops/migrate $(ENV) $(MIGRATION) $(DIRECTION)

execute:
	@./devops/execute $(ENV) $(SCRIPT) $(ARG)
