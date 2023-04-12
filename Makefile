default: help

help:
	@echo ""
	@echo "clean\t\tremove all artifacts and dependencies"
	@echo "start\t\tstart local development setup with docker"
	@echo "stop\t\tstop local development setup with docker"
	@echo "test\t\trun tests locally"

build: clean-dist
	@echo "\nBuilding Docker Image:\n"
	docker build -t pythonindia/junction:latest .

start:
	@echo "\nStarting dev environment:\n"
	@docker compose up

stop: clean

db-console:
	@echo "\nStarting db console:\n"
	@docker exec -it db sh -c "psql --username=postgres --db=junction"

clean: clean-dev clean-test

clean-dev:
	@docker compose down

clean-test:
	@docker compose -f docker-compose.test.yml rm -f

test: clean-test
	@docker compose -f docker-compose.test.yml build
	@docker compose -f docker-compose.test.yml up --abort-on-container-exit --exit-code-from web

.PHONY: default help build start stop clean clean-dev test