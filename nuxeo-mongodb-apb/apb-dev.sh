#!/bin/bash

SB_IMAGE_NAME=nuxeo-mongodb-apb
if [[ $1 ]]; then OPERATION=$1; else OPERATION="bdp"; fi
PARAMS_JSON=$(<secure-params.json)

function buildAPB {
   apb build
}

function runAPB {
    docker run --rm --net=host -v $HOME/.kube:/opt/apb/.kube:z -u $UID \
$SB_IMAGE_NAME \
$ACTION \
-e "$PARAMS_JSON"
}

case "$OPERATION" in
    *b*) buildAPB ;;&
    *d*) ACTION=deprovision runAPB ;;&
    *p*) ACTION=provision runAPB ;;&
esac

