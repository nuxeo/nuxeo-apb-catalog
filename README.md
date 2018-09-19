# Catalog of Ansible Playbook Bundles for Nuxeo

This repository contains Ansible Playbook Bundles for deploying the Nuxeo content services platform container itself as well as the backing service containers upon which it depends. See the [Ansible PlayBook Bundle](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle) documentation and the [Automation Broker](http://automationbroker.io) documentation pages for details.

The APBs are pushed in the [Nuxeo APB Catalog](https://hub.docker.com/r/nuxeoapbcatalog/) organization in DockerHub.

To activate them, simply add the following snippet in the Ansible Service Broker configuration:

```
registry:
 - type: dockerhub
    name: nuxeo-apb-catalog
    url:
    org:  nuxeoapbcatalog
    tag:  2.0
    white_list:
     - ".*-apb$"

    auth_type: ""
    auth_name: ""

dao:
  etcd_host: asb-etcd.openshift-ansible-service-broker.svc
  etcd_port: 2379
  etcd_ca_file: /var/run/secrets/kubernetes.io/serviceaccount/service-ca.crt
  etcd_client_cert: /var/run/asb-etcd-auth/client.crt
  etcd_client_key: /var/run/asb-etcd-auth/client.key
log:
  stdout: true
  level: info
  color: true
openshift:
  host: ""
  ca_file: ""
  bearer_token_file: ""
  namespace: openshift-ansible-service-broker
  sandbox_role: cluster-admin
  image_pull_policy: IfNotPresent
  keep_namespace: false
  keep_namespace_on_error: true
broker:
  dev_broker: dev
  bootstrap_on_startup: true
  refresh_interval: 600s
  launch_apb_on_bind: true
  output_request: false
  recovery: true
  ssl_cert_key: /etc/tls/private/tls.key
  ssl_cert: /etc/tls/private/tls.crt
  auto_escalate: True
  auth:
    - type: basic
      enabled: false
```

Notice the `sandbox_role` which is set to `cluster-admin` as some APB needs to specify some SCC (Elasticsearch). That also means that we must give the APB serviceaccount user the `cluster-admin` role:

```
oc adm policy add-cluster-role-to-user cluster-admin system:serviceaccount:openshift-ansible-service-broker:asb
```

As we use asynchronous binding, we also has set `launch_apb_on_bind` to `true`. This also requires to setup Openshift accordingly following https://blog.openshift.com/asynchronous-bind-with-the-automation-broker/

and finally rollout the new ASB service:

```
oc rollout latest dc/asb -n openshift-ansible-service-broker
```


In order to have our APB present in the catalog, we also have to tell the Cluster service broker to relist the services:


```
oc edit clusterservicebroker ansible-service-broker
```

and then increase the `relistRequests` value and save.

# Development


## Create the build
In a given project you can create those builds:

```
oc new-build https://github.com/nuxeo-sandbox/nuxeo-apb-catalog --context-dir=nuxeo-apb --name=nuxeo-apb
oc new-build https://github.com/nuxeo-sandbox/nuxeo-apb-catalog --context-dir=nuxeo-mongodb-apb --name=nuxeo-mongodb-apb
oc new-build https://github.com/nuxeo-sandbox/nuxeo-apb-catalog --context-dir=nuxeo-elasticsearch-apb --name=nuxeo-elasticsearch-apb
oc new-build https://github.com/nuxeo-sandbox/nuxeo-apb-catalog --context-dir=nuxeo-kafka-apb --name=nuxeo-kafka-apb
```


## Add builts APBs in the registry

Edit the `openshift-ansible-service-broker` configmap:

```
registry:

   ...

    auth_type: ""
    auth_name: ""
  - type: local_openshift
    name: nuxeo
    namespaces: ['int-apb-dev']
    white_list: [ ".*-apb"]

  ...
```

For ease of development, you can also edit the broker configuration:


```
...
openshift:
  ...
  image_pull_policy: Always
  ...
broker:
  ...
  refresh_interval: 60s
  ...
...
```

## Rebuild

Before rebuilding the APBs, we have to get rid of the old images:
```
oc get images | grep nuxeo.*-apb | awk '{ print $1 }' | while read i; do oc delete image $i;done
oc start-build nuxeo-apb && oc start-build nuxeo-mongodb-apb && oc start-build nuxeo-elasticsearch-apb && oc start-build nuxeo-kafka-apb

```

# Licensing

Most of the source code in the Nuxeo Platform is copyright Nuxeo and
contributors, and licensed under the Apache License, Version 2.0.

See [/licenses](/licenses) and the documentation page [Licenses](http://doc.nuxeo.com/x/gIK7) for details.

# About Nuxeo

Nuxeo dramatically improves how content-based applications are built, managed and deployed, making customers more agile, innovative and successful. Nuxeo provides a next generation, enterprise ready platform for building traditional and cutting-edge content oriented applications. Combining a powerful application development environment with SaaS-based tools and a modular architecture, the Nuxeo Platform and Products provide clear business value to some of the most recognizable brands including Verizon, Electronic Arts, Sharp, FICO, the U.S. Navy, and Boeing. Nuxeo is headquartered in New York and Paris. More information is available at [www.nuxeo.com](http://www.nuxeo.com).


