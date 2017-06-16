IMAGE:=nudj/server

CWD=$(shell pwd)

.PHONY: build up down development staging

build:
	@docker build -t $(IMAGE):local local

up:
	@cd local && docker-compose up -d && docker-compose logs -f

down:
	@cd local && docker-compose down

dump:
	@docker-compose exec arangodb arangodump --output-directory "/dump" --server.database "nudj" --server.username "nudjtech" --server.password "nudjtechpass"

development:
	./release

staging:
	./release staging
