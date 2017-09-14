IMAGE:=nudj/server

CWD=$(shell pwd)

.PHONY: build up down

build:
	@docker build -t $(IMAGE):local local

up:
	@docker-compose up -d --force-recreate && \
		docker-compose logs -f

down:
	@docker-compose down
