IMAGE:=nudj/server

CWD=$(shell pwd)

.PHONY: build up down staging

build:
	@docker build -t $(IMAGE):local local

up:
	@cd local && docker-compose up -d && docker-compose logs -f

down:
	@cd local && docker-compose down

staging:
	./release
