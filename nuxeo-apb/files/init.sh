#!/bin/sh
cp -f /docker-entrypoint-initnuxeo.d/log4j.xml $NUXEO_HOME/lib/log4j.xml

if [ ! -f $NUXEO_DATA/instance.clid -a -f /opt/nuxeo/connect/connect.properties ]; then
  . /opt/nuxeo/connect/connect.properties
  if [ -n "$NUXEO_CONNECT_USERNAME" -a -n "$NUXEO_CONNECT_PASSWORD" -a -n "$NUXEO_STUDIO_PROJECT" ]; then  
    echo "---> Registering instance on connect"
    nuxeoctl register $NUXEO_CONNECT_USERNAME $NUXEO_STUDIO_PROJECT dev openshift $NUXEO_CONNECT_PASSWORD
  fi
fi