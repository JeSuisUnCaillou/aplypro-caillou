DOCKER-RUN = docker-compose run --rm --entrypoint=""
BUNDLE-EXEC = bundle exec

build:
	docker-compose build

up:
	docker-compose up

down:
	docker-compose down

.PHONY: db
db:
	$(DOCKER-RUN) db psql -U postgres -h db -d development

sh:
	$(DOCKER-RUN) web $(BUNDLE-EXEC) bash

guard:
	$(DOCKER-RUN) web $(BUNDLE-EXEC) guard

lint:
	$(DOCKER-RUN) web $(BUNDLE-EXEC) rubocop

debug:
	$(DOCKER-RUN) web $(BUNDLE-EXEC) rdbg -A web 12345

cl:
	$(DOCKER-RUN) web bin/rails console

rs:
	docker-compose exec web touch tmp/restart.txt
