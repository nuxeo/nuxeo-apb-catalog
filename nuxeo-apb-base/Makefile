#DOCKERHOST = docker.io
DOCKERHOST = 172.30.1.1:5000
DOCKERORG = nuxeoapbcatalog
IMAGENAME = nuxeo-apb-base
TAG = latest
USER=$(shell id -u)
PWD=$(shell pwd)
#build_and_push: apb_build docker_push apb_push
build_and_push: apb_build docker_push

.PHONY: apb_build
apb_build:
	docker build -t $(DOCKERHOST)/$(DOCKERORG)/$(IMAGENAME):$(TAG) .

.PHONY: docker_push
docker_push:
	docker push $(DOCKERHOST)/$(DOCKERORG)/$(IMAGENAME):$(TAG)

.PHONY: apb_push
apb_push:
	docker run --rm --privileged -v $(PWD):/mnt:z -v $(HOME)/.kube:/.kube -v /var/run/docker.sock:/var/run/docker.sock -u $(USER) docker.io/ansibleplaybookbundle/apb-tools:latest push
