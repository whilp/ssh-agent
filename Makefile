DOCKER ?= docker

image:
	$(DOCKER) build -t whilp/ssh-agent:latest -f Dockerfile .
