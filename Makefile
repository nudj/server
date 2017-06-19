IMAGE:=nudj/server

CWD=$(shell pwd)

.PHONY: build up down dump development staging

build:
	@docker build -t $(IMAGE):local local

up:
	@cd local && docker-compose up -d && docker-compose logs -f

down:
	@cd local && docker-compose down

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
