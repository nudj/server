IMAGE:=nudj/server

CWD=$(shell pwd)

.PHONY: build dev run deploy

build:
	docker build -t $(IMAGE) .

dev:
	@docker-compose \
		-p nudjdev \
		-f $(CWD)/docker-compose-dev.yml \
		up \
		--force-recreate

run:
	@docker-compose \
		-p nudj \
		-f $(CWD)/docker-compose.yml \
		up \
		--force-recreate
