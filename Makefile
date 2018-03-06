IMAGE:=nudj/server
IMAGEUI:=nudj/test-ui
COREAPPS:=server redis db
DOCKERCOMPOSE:=docker-compose -p nudj
CWD=$(shell pwd)

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
	@env -i $$(node ./scripts/extract-envkeys.js $(ENV) DB_USER DB_PASS) ./scripts/release $(ENV) $(SERVER) $(WEB) $(HIRE) $(ADMIN) $(API)

migrate:
	@env -i $$(node ./scripts/extract-envkeys.js $(ENV) DB_USER DB_PASS) ./scripts/migrate $(ENV) $(MIGRATION) $(DIRECTION)

devopsBuild:
	@docker build -t nudj/devops --build-arg NPM_TOKEN=${NPM_TOKEN} -f ./Dockerfile .

devops:
	@$(DOCKERCOMPOSE) -f ./docker-compose-devops.yml run --rm \
		-v $(CWD)/.env-devops:/usr/src/.env \
		-v $(CWD)/src/migrations:/usr/src/migrations \
		devops \
		node ./migrations $(MIGRATION) $(DIRECTION)

devopsTest:
	@$(DOCKERCOMPOSE) -f ./docker-compose-devops.yml run --rm \
		-v $(CWD)/.env-devops:/usr/src/.env \
		-v $(CWD)/src/migrations:/usr/src/migrations \
		-v $(CWD)/src/test:/usr/src/test \
		devops \
		/bin/zsh -c 'echo "Running tests..." && ./node_modules/.bin/standard && ./node_modules/.bin/mocha --recursive test'

devopsTdd:
	@$(DOCKERCOMPOSE) -f ./docker-compose-devops.yml run --rm \
		-v $(CWD)/.env-devops:/usr/src/.env \
		-v $(CWD)/src/migrations:/usr/src/migrations \
		-v $(CWD)/src/test:/usr/src/test \
		devops \
		/bin/zsh -c './node_modules/.bin/nodemon \
			--quiet \
			--watch ./ \
			--delay 250ms \
			-x "echo \"Running tests...\" && ./node_modules/.bin/mocha --recursive test && echo \"Running tests complete\" || exit 1"'
