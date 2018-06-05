#!/usr/bin/env bash
set -ex
# Greatly inspired by the init script of the MongoDB replicaset helm chart.


hostname=$(hostname)
# Generate the ca cert
ca_crt=/caroot/tls.crt
ca_key=/caroot/tls.key
conf_dir=/etc/kafka/secrets

key_store=$conf_dir/keystore.p12
trust_store=$conf_dir/truststore.p12

rm -f $key_store
rm -f $trust_store


pushd $conf_dir


# Create Truststore
keytool -keystore $trust_store -storetype pkcs12 -noprompt -alias CARoot -import -file $ca_crt -storepass changeit

# Generate a key in the keystore
keytool -genkey -noprompt \
                 -alias ${hostname} \
                 -dname "CN=${hostname}.${DN_SUFFIX}" \
                 -keystore $key_store \
                 -keyalg RSA \
                 -storetype pkcs12 \
                 -storepass changeit

# Create CSR, sign the key and import back into keystore
keytool -keystore $key_store \
           -alias ${hostname} \
           -certreq \
           -file key.csr \
           -storetype pkcs12 \
           -storepass changeit

# Sign CSR
openssl x509 -req -CA $ca_crt -CAkey $ca_key -in key.csr -out key.crt -days 3650 -CAcreateserial -CAserial /tmp/tls.srl -extensions server_ext

# Import CA cert in keystore
keytool -keystore $key_store -storetype pkcs12  --noprompt -alias CARoot -import -file $ca_crt -storepass changeit

# Import signed key  cert in keystore
keytool -keystore $key_store --noprompt \
    -alias ${hostname} \
    -storetype pkcs12 \
    -import \
    -file key.crt \
    -storepass changeit

rm -f key.csr
rm -f key.crt


popd


