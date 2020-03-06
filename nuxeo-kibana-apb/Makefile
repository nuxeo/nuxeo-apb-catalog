NAMESPACE = int-arender-dev
CONFIG=`cat config.json`
DOCKERHOST = docker.io
DOCKERORG = nuxeoapbcatalog
IMAGENAME = nuxeo-kibana-apb
TAG = latest
USER=$(shell id -u)
PWD=$(shell pwd)
build_and_push: build push

.PHONY: build
build:
		apb prepare
		docker build -t $(DOCKERHOST)/$(DOCKERORG)/$(IMAGENAME):$(TAG) .

.PHONY: push
push:
		docker push $(DOCKERHOST)/$(DOCKERORG)/$(IMAGENAME):$(TAG)


provision: build
	 	docker run -ti --rm --net=host -v ${HOME}/.kube:/opt/apb/.kube:z -u $(USER) $(DOCKERHOST)/$(DOCKERORG)/$(IMAGENAME):$(TAG) provision -e "${CONFIG}"

deprovision: build
		docker run -ti --rm --net=host -v ${HOME}/.kube:/opt/apb/.kube:z -u $(USER) $(DOCKERHOST)/$(DOCKERORG)/$(IMAGENAME):$(TAG) deprovision -e "${CONFIG}"

