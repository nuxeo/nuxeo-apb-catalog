#!/bin/bash

SB_IMAGE_NAME=nuxeo-mongodb-apb
if [[ $1 ]]; then OPERATION=$1; else OPERATION="bdp"; fi

function buildAPB {
   apb build
}

function runAPB {
    docker run --rm --net=host -v $HOME/.kube:/opt/apb/.kube:z -u $UID \
$SB_IMAGE_NAME \
$ACTION \
--extra-vars "_apb_plan_id=secure-replicaset" \
--extra-vars "replicas=3" \
--extra-vars "replicaSetName=rs0" \
--extra-vars "podDisruptionBudget='{minAvailable: 2}'" \
--extra-vars "port=27017" \
--extra-vars "installImage_repository=k8s.gcr.io/mongodb-install" \
--extra-vars "installImage_tag=0.6" \
--extra-vars "installImage_pullPolicy=IfNotPresent" \
--extra-vars "image_repository=docker.io/mongo" \
--extra-vars "image_tag=3.4" \
--extra-vars "image_pullPolicy=IfNotPresent" \
--extra-vars "podAnnotations='{}'" \
--extra-vars "securityContext='{}'" \
--extra-vars "resources='{limits: {cpu: 500m, memory: 512Mi}, requests: {cpu: 100m, memory: 256Mi}}'" \
--extra-vars "persistentVolume_storageClass=-" \
--extra-vars "persistentVolume_accessMode=ReadWriteOnce" \
--extra-vars "persistentVolume_size=10Gi" \
--extra-vars "persistentVolume_annotations='{}'" \
--extra-vars "tls_casubjectDistinguishedName=/CN=nuxeo-backings.mongodb.svc/OU=engineering/O=nuxeo/L=irvine/S=ca/C=us" \
--extra-vars "auth_adminUser=admin" \
--extra-vars "auth_adminPassword=admin" \
--extra-vars "auth_username=nuxeo" \
--extra-vars "database=nuxeo" \
--extra-vars "serviceAnnotations='{}'" \
--extra-vars "nodeSelector='{}'" \
--extra-vars "affinity='{}'" \
--extra-vars "tolerations='{}'" \
--extra-vars "livenessProbe_initialDelaySeconds=5" \
--extra-vars "livenessProbe_timeoutSeconds=1" \
--extra-vars "livenessProbe_failureThreshold=3" \
--extra-vars "livenessProbe_periodSeconds=10" \
--extra-vars "livenessProbe_successThreshold=1" \
--extra-vars "readinessProbe_initialDelaySeconds=5" \
--extra-vars "readinessProbe_timeoutSeconds=1" \
--extra-vars "readinessProbe_failureThreshold=3" \
--extra-vars "readinessProbe_periodSeconds=10" \
--extra-vars "readinessProbe_successThreshold=1"
}
#--extra-vars "auth_adminPassword=password" \
#--extra-vars "auth_password=password" \

case "$OPERATION" in
    *b*) buildAPB ;;&
    *d*) ACTION=deprovision runAPB ;;&
    *p*) ACTION=provision runAPB ;;&
esac

