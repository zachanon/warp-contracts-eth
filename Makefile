DOCKER ?= docker
DOCKER_NAME ?= oracle-panopticon:latest
DOCKER_EXTRA ?= --network=host
NPM ?= npm

all:
	@echo "Please see README.md for instructions (or view the Makefile)"

docker-pull:
	$(DOCKER) pull ubuntu:latest

docker-build: Dockerfile
	$(DOCKER) build -t $(DOCKER_NAME) $(DOCKER_EXTRA) .

shell: docker-shell

# Runs interactive shell, with current dir mapped into container, for fast development turnaround
docker-shell: docker-build
	$(DOCKER) run --rm $(DOCKER_EXTRA) -ti -v `pwd`:/app/ $(DOCKER_NAME)

clean:
	rm -rf node_modules build reports

.PHONY:
ganache-cli: node_modules/.bin/ganache-cli
	./node_modules/.bin/ganache-cli

node_modules/.bin/ganache-cli:
	$(NPM) install
