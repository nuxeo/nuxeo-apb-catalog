#!/bin/bash

SB_IMAGE_NAME=nuxeo-mongodb-apb
NAMESPACE=$(kubectl config current-context | awk -F '/' '{print $1}')
POD_NAMESPACE=ansible-service-broker
PARAMS_JSON=$(<secure-params.json)
if [[ $1 ]]; then OPERATION=$1; else OPERATION="bdp"; fi

function buildAPB {
   apb build
}

function runAPB {
    # Create stub-asb-binding deployment to facilitate asb credential binding in 'docker run' environment
    local PHRASE=$(head /dev/urandom | tr -dc a-z0-9 | head -c 5 ; echo '')
    local DEPLOYMENT_NAME=stub-asb-binding-$PHRASE
    kubectl run $DEPLOYMENT_NAME --image=busybox --namespace=$POD_NAMESPACE
    local POD_NAME=$(kubectl get po --namespace=$POD_NAMESPACE \
        --selector="run=${DEPLOYMENT_NAME}" --no-headers --output='custom-columns=NAME:.metadata.name')

    docker run --rm --net=host -v $HOME/.kube:/opt/apb/.kube:z -u $UID \
-e NAMESPACE="$NAMESPACE" \
-e POD_NAMESPACE="$POD_NAMESPACE" \
-e POD_NAME="$POD_NAME" \
$SB_IMAGE_NAME \
$ACTION \
-e "$PARAMS_JSON"

    # Remove stub-asb-binding deployment
    kubectl delete deployment $DEPLOYMENT_NAME --ignore-not-found --namespace=$POD_NAMESPACE
}

case "$OPERATION" in
    *b*) buildAPB ;;&
    *d*) ACTION=deprovision runAPB ;;&
    *p*) ACTION=provision runAPB ;;&
esac
