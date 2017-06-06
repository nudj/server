IMAGE:=nudj/server

CWD=$(shell pwd)

.PHONY: build buildStaging pushStaging staging buildProd dev run

build:
	@cd local && docker build -t $(IMAGE) .

buildStaging:
	@cd ./staging && docker build -t $(IMAGE):staging .

pushStaging:
	@cd ./staging && docker push $(IMAGE):staging

staging: buildStaging pushStaging

buildProd:
	cd production && docker build -t $(IMAGE):0.2.2 .

up:
	@cd local && docker-compose up -d && docker-compose logs -f

down:
	@cd local && docker-compose down
