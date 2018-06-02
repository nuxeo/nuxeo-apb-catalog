#!/usr/bin/env bash
set -ex
# Greatly inspired by the init script of the MongoDB replicaset helm chart.


hostname=$(hostname)
# Generate the ca cert
ca_crt=/caroot/tls.crt
ca_key=/caroot/tls.key
conf_dir=/usr/share/elasticsearch/config/

key_store=$conf_dir/searchguard-ssl/keystore.p12
trust_store=$conf_dir/searchguard-ssl/truststore.p12
admin_keystore=$conf_dir/searchguard-ssl/admin_keystore.p12

rm -f $key_store
rm -f $trust_store
rm -f $admin_store



pushd $conf_dir/searchguard-ssl


# Create Truststore
keytool -keystore $trust_store -storetype pkcs12 -noprompt -alias CARoot -import -file $ca_crt -storepass changeit

# Generate a key in the keystore
keytool -genkey -noprompt \
                 -alias searchguardkey \
                 -ext san=dns:${hostname}.elasticsearch.svc,dns:localhost,ip:127.0.0.1,oid:1.2.3.4.5.5 \
                 -dname "CN=${hostname}.searchguard.elasticsearch.svc${DN_SUFFIX}" \
                 -keystore $key_store \
                 -keyalg RSA \
                 -storetype pkcs12 \
                 -storepass changeit

# Create CSR, sign the key and import back into keystore
keytool -keystore $key_store \
           -alias searchguardkey \
           -certreq \
           -file key.csr \
           -storetype pkcs12 \
           -storepass changeit \
           -ext san=dns:${hostname}.elasticsearch.svc,dns:localhost,ip:127.0.0.1,oid:1.2.3.4.5.5
# Sign CSR
openssl x509 -req -CA $ca_crt -CAkey $ca_key -in key.csr -out key.crt -days 3650 -CAcreateserial -CAserial /tmp/tls.srl -extensions server_ext

# Import CA cert in keystore
keytool -keystore $key_store -storetype pkcs12  --noprompt -alias CARoot -import -file $ca_crt -storepass changeit

# Import signed key  cert in keystore
keytool -keystore $key_store --noprompt \
    -alias searchguardkey \
    -storetype pkcs12 \
    -import \
    -file key.crt \
    -storepass changeit \
    -ext san=dns:${hostname}.elasticsearch.svc,dns:localhost,ip:127.0.0.1,oid:1.2.3.4.5.5

rm -f key.csr
rm -f key.crt



# Generate admin key
keytool -genkey -noprompt \
     -alias adminKey \
     -ext san=dns:${hostname}.searchguard.elasticsearch.svc,dns:localhost,ip:127.0.0.1,oid:1.2.3.4.5.5 \
     -dname "CN=admin,O=nuxeo,C=com" \
     -keystore $admin_keystore \
     -keyalg RSA \
     -storetype pkcs12 \
     -storepass changeit

# Create CSR, sign the key and import back into keystore
keytool -keystore $admin_keystore \
   -alias adminKey \
   -certreq \
   -file key.csr \
   -storetype pkcs12 \
   -storepass changeit \
   -ext san=dns:${hostname}.searchguard.elasticsearch.svc,dns:localhost,ip:127.0.0.1,oid:1.2.3.4.5.5

# Sign CSR
openssl x509 -req -CA $ca_crt -CAkey $ca_key -in key.csr -out key.crt -days 3650 -CAcreateserial -CAserial /tmp/tls.srl -extensions server_ext

# Import CA cert in keystore
keytool -keystore $admin_keystore -storetype pkcs12  --noprompt -alias CARoot -import -file $ca_crt -storepass changeit

# Import signed key  cert in keystore
keytool -keystore $admin_keystore --noprompt \
    -alias adminKey \
    -storetype pkcs12 \
    -import \
    -file key.crt \
    -storepass changeit \
    -ext san=dns:${hostname}.searchguard.elasticsearch.svc,dns:localhost,ip:127.0.0.1,oid:1.2.3.4.5.5


rm -f key.csr
rm -f key.crt

chown -R elasticsearch:elasticsearch $conf_dir/searchguard-ssl/

popd


