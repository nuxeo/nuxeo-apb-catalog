#!/bin/sh

# Use the log4j we get from the config.
cp -f /docker-entrypoint-initnuxeo.d/log4j.xml $NUXEO_HOME/lib/log4j.xml


# Configure queues handling
QUEUES_CONFIG=/docker-entrypoint-initnuxeo.d/interactive-queues-config.xml
if [ $IS_WORKER == "1" ]; then
	QUEUES_CONFIG=/docker-entrypoint-initnuxeo.d/worker-queues-config.xml
fi
cp $QUEUES_CONFIG /opt/nuxeo/server/templates/common/config


if [ ! -f $NUXEO_DATA/instance.clid -a -f /opt/nuxeo/connect/connect.properties ]; then
  . /opt/nuxeo/connect/connect.properties
  if [ -n "$NUXEO_CONNECT_USERNAME" -a -n "$NUXEO_CONNECT_PASSWORD" -a -n "$NUXEO_STUDIO_PROJECT" ]; then  
    echo "---> Registering instance on connect"
    nuxeoctl register $NUXEO_CONNECT_USERNAME $NUXEO_STUDIO_PROJECT dev openshift $NUXEO_CONNECT_PASSWORD
  fi
fi