IMAGE:=nudj/server

CWD=$(shell pwd)

.PHONY: build buildStaging pushStaging staging buildProd dev run

build:
	@docker build -t $(IMAGE) local

buildStaging:
	@docker build -t $(IMAGE):staging staging

pushStaging:
	@docker push $(IMAGE):staging

staging: buildStaging pushStaging

buildProd:
	@docker build -t $(IMAGE):0.2.2 production

up:
	@cd local && docker-compose up -d && docker-compose logs -f

down:
	@cd local && docker-compose down
