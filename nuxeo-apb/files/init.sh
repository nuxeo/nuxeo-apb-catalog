#!/bin/sh

# Use the log4j we get from the config.
cp -f /docker-entrypoint-initnuxeo.d/log4j.xml $NUXEO_HOME/lib/log4j.xml


#cp $JAVA_HOME/jre/lib/security/cacerts $NUXEO_DATA/cacerts
TRUSTSTORE_PATH=$NUXEO_DATA/cacerts


NUXEO_ENV_NAME=${NUXEO_ENV_NAME:-nuxeo}

# Configure MongoDB bindings
if [ -f /opt/nuxeo/bindings/mongodb/uri ]; then
	MONGODB_URI=$(< /opt/nuxeo/bindings/mongodb/uri)
	MONGODB_DBNAME=$(< /opt/nuxeo/bindings/mongodb/dbname)
	cat >> $NUXEO_CONF <<EOT

nuxeo.mongodb.server=${MONGODB_URI}
nuxeo.mongodb.dbname=${MONGODB_DBNAME}
EOT

	if [ -f /opt/nuxeo/bindings/mongodb/tls_cacert ]; then

		# Temporary hack: Nuxeo launcher doesnt allow to specify Truststore https://jira.nuxeo.com/browse/NXP-25095
		# So we have to deactivate the mongodb check that require a specific truststore in SSL
		sed -i /mongodb.check/d /opt/nuxeo/server/templates/mongodb/nuxeo.defaults

		# Remove cert if already set.
		if [ -f $TRUSTSTORE_PATH ]; then
			set +e
			keytool -list -keystore $TRUSTSTORE_PATH -alias MongoDBCaCert -storepass changeit -noprompt
			if [ "$?" == "0" ]; then
				keytool -delete -keystore $TRUSTSTORE_PATH -alias MongoDBCaCert -storepass changeit -noprompt
			fi
			set -e
		fi

		base64 -d /opt/nuxeo/bindings/mongodb/tls_cacert > /tmp/cert
		keytool -import -file /tmp/cert -alias MongoDBCaCert -keystore $TRUSTSTORE_PATH -storepass changeit -noprompt
	fi

fi


# Configure Elasticsearch bindings
if [ -d /opt/nuxeo/bindings/elasticsearch ]; then
	ELASTICSEARCH_CLUSTERNAME=$(< /opt/nuxeo/bindings/elasticsearch/clustername)
	ELASTICSEARCH_URI=$(< /opt/nuxeo/bindings/elasticsearch/uri)

	cat >> $NUXEO_CONF <<EOT
elasticsearch.addressList=${ELASTICSEARCH_URI}
elasticsearch.client=RestClient
elasticsearch.httpReadOnly.baseUrl=${ELASTICSEARCH_URI}
elasticsearch.clusterName=${ELASTICSEARCH_CLUSTERNAME}
elasticsearch.indexName=${NUXEO_ENV_NAME}
EOT

	if [ -f /opt/nuxeo/bindings/elasticsearch/username ]; then
			ELASTICSEARCH_USERNAME=$(< /opt/nuxeo/bindings/elasticsearch/username)
			ELASTICSEARCH_PASSWORD=$(< /opt/nuxeo/bindings/elasticsearch/password)
			cat >> $NUXEO_CONF <<EOT
elasticsearch.restClient.username=${ELASTICSEARCH_USERNAME}
elasticsearch.restClient.password=${ELASTICSEARCH_PASSWORD}
EOT
	fi


	if [ -f /opt/nuxeo/bindings/elasticsearch/tls_cacert ]; then

		# Remove cert if already set.
		if [ -f $TRUSTSTORE_PATH ]; then
			set +e
			keytool -list -keystore $TRUSTSTORE_PATH -alias ElasticsearchCaCert -storepass changeit -noprompt
			if [ "$?" == "0" ]; then
				keytool -delete -keystore $TRUSTSTORE_PATH -alias ElasticsearchCaCert -storepass changeit -noprompt
			fi
			set -e
		fi

		base64 -d /opt/nuxeo/bindings/elasticsearch/tls_cacert > /tmp/cert
		keytool -import -file /tmp/cert -alias ElasticsearchCaCert -keystore $TRUSTSTORE_PATH -storepass changeit -noprompt
	fi

fi


# Configure Kafka bindings
if [ -d /opt/nuxeo/bindings/kafka ]; then

	KAFKA_URI=$(< /opt/nuxeo/bindings/kafka/uri)

	cat >> $NUXEO_CONF <<EOT
kafka.enabled=true
nuxeo.stream.work.enabled=true
kafka.bootstrap.servers=${KAFKA_URI}
kafka.topicPrefix=${NUXEO_ENV_NAME}-
kafka.offsets.retention.minutes=20160
nuxeo.pubsub.provider=stream
EOT


	if [ -f /opt/nuxeo/bindings/kafka/tls_cacert ]; then

		# Remove cert if already set.
		if [ -f $TRUSTSTORE_PATH ]; then
			set +e
			keytool -list -keystore $TRUSTSTORE_PATH -alias KafkaCaCert -storepass changeit -noprompt
			if [ "$?" == "0" ]; then
				keytool -delete -keystore $TRUSTSTORE_PATH -alias KafkaCaCert -storepass changeit -noprompt
			fi
			set -e
		fi

		base64 -d /opt/nuxeo/bindings/kafka/tls_cacert > /tmp/cert
		keytool -import -file /tmp/cert -alias KafkaCaCert -keystore $TRUSTSTORE_PATH -storepass changeit -noprompt
	fi

fi


if [ ! -f $NUXEO_DATA/instance.clid -a -f /opt/nuxeo/connect/connect.properties ]; then
  . /opt/nuxeo/connect/connect.properties
  if [ -n "$NUXEO_CONNECT_USERNAME" -a -n "$NUXEO_CONNECT_PASSWORD" -a -n "$NUXEO_STUDIO_PROJECT" ]; then
    echo "---> Registering instance on connect"
    nuxeoctl register $NUXEO_CONNECT_USERNAME $NUXEO_STUDIO_PROJECT dev openshift $NUXEO_CONNECT_PASSWORD
  fi
fi


if [ -f $NUXEO_DATA/instance.clid ]  && [ ${NUXEO_INSTALL_HOTFIX:='true'} == "true" ]; then
	echo "---> Installing hotfixes"
	nuxeoctl mp-hotfix
fi
