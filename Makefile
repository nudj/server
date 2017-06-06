IMAGE:=nudj/server

CWD=$(shell pwd)

.PHONY: build buildStaging pushStaging staging buildProd dev run

build:
	@docker build -t $(IMAGE) local

buildStaging:
	@docker build -t $(IMAGE):staging staging

pushStaging:
	@docker push $(IMAGE):staging

updateStaging:
	@scp -r staging/ssl nudjstaging:/home/nudjtech/staging/ssl
	@scp staging/docker-compose.yml nudjstaging:/home/nudjtech/staging/docker-compose.yml
	@scp staging/.env-api nudjstaging:/home/nudjtech/staging/.env-api
	@scp staging/.env-db nudjstaging:/home/nudjtech/staging/.env-db
	@scp staging/.env-web nudjstaging:/home/nudjtech/staging/.env-web
	@scp staging/.htpasswd nudjstaging:/home/nudjtech/staging/.htpasswd

restartStaging:
	@ssh -t nudjstaging 'cd staging && sudo docker ps'

staging:
	./release

production:
	./release production

up:
	@cd local && docker-compose up -d && docker-compose logs -f

down:
	@cd local && docker-compose down
