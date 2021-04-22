DOCKER_NAME = oracle-panopticon:latest

all:
	@echo "..."

docker-pull:
	docker pull ubuntu:latest

docker-build: Dockerfile
	docker build . -t $(DOCKER_NAME) --network=host

cli: docker-build
	docker run --rm --net=host -ti $(DOCKER_NAME)
