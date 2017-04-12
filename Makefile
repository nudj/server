IMAGE:=nudj/server

CWD=$(shell pwd)

.PHONY: build dev run

build:
	cd dev && docker build -t $(IMAGE) .

up:
	@cd dev && docker-compose up -d && docker-compose logs -f

down:
	@cd dev && docker-compose down
