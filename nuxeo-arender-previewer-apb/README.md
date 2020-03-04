Nuxeo ARender Previewer APB
===========================

This Ansible Playbook Bundle deploys the ARender infrastructure in Openshift.


## Prerequisites

To be able to build the package, you need to instanll the [APB CLI Tool](https://github.com/ansibleplaybookbundle/ansible-playbook-bundle/blob/master/docs/apb_cli.md#installing-the-apb-tool)

## Build the Docker image

```console
# make build
apb prepare
Running APB image: docker.io/ansibleplaybookbundle/apb-tools:canary
Finished writing dockerfile.
docker build -t docker.io/nuxeo-arender-previewer-apb/nuxeo-arender-previewer:latest .
Sending build context to Docker daemon   89.6kB
Step 1/7 : FROM ansibleplaybookbundle/apb-base
 ---> 1f7ea01fe3a0
Step 2/7 : LABEL "com.redhat.apb.spec"="LS0tCnZlcnNpb246IDEuMApuYW1lOiBudXhlby1hcmVuZGVyLXJlbmRpdGlvbi1hcGIKZGVzY3JpcHRpb246IEFSZW5kZXIgUmVuZGl0aW9uIGRlcGxveW1lbnQgaW4gT3BlbnNoaWZ0IGZvciBOdXhlbwpiaW5kYWJsZTogVHJ1ZQphc3luYzogb3B0aW9uYWwKdGFnczoKICAtIG51eGVv
...
CiAgLSBudXhlby1hcmVuZGVyLXJlbmRpdGlvbgptZXRhZGF0YToKICBkaXNwbGF5TmFtZTogQVJlbmJXWCkKICAgICAgZGlzcGxheV9ncm91cDogQ29udGFpbmVyIFNwZWNzCgogICAgLSBuYW1lOiBhcmVuZGVyX2RlYnVnX3BvZAogICAgICBkZWZhdWx0OiBmYWxzZQogICAgICB0eXBlOiBib29sZWFuCiAgICAgIGRpc3BsYXlfdHlwZTogY2hlY2tib3gKICAgICAgdGl0bGU6IERlcGxveSBhIGRlYnVnIHBvZAogICAgICBkaXNwbGF5X2dyb3VwOiBPdGhlcnMKCg=="
 ---> Using cache
 ---> 8008090e4108
Step 3/7 : ADD playbooks /opt/apb/actions
 ---> Using cache
 ---> 9a56432a5881
Step 4/7 : ADD . /opt/ansible/roles/nuxeo-arender-apb/
 ---> c75b0dd320fe
Step 5/7 : ADD . /opt/ansible/roles/nuxeo-arender-previewer-apb/
 ---> eaea3b7000a4
Step 6/7 : RUN chmod -R g=u /opt/{ansible,apb}
 ---> Running in aab9559a7e51
Removing intermediate container aab9559a7e51
 ---> abc3866aa64a
Step 7/7 : USER apb
 ---> Running in a2a1f8062f40
Removing intermediate container a2a1f8062f40
 ---> ebf9108618ef
Successfully built ebf9108618ef
Successfully tagged nuxeo-arender-previewer-apb/nuxeo-arender-previewer:latest
```

## Deploy an ARender instance

Review the [`config.json`](./config.json) file and adjust to the needed configuration needed. The parameters of that file are the one that are present in the [`apb.yaml`](./apb.yml). The default values can be found either in that file or in [`defaults/main.yml`](./defaults/main.yml).

First switch to the target Openshift project. You can then execute the Docker image with those parameters using another `make` rule.

```console
# oc project int-arender-dev
Now using project "int-arender-dev" on server "https://myserver:443".
# make provision
DEPRECATED: APB playbooks should be stored at /opt/apb/project
 [WARNING]: Found variable using reserved name: name


PLAY [Playbook to provision an ARender Previewer service] **********************


...



PLAY RECAP *********************************************************************
localhost                  : ok=6    changed=5    unreachable=0    failed=0

```

## Undeploy an ARender instance

```console
make deprovision
```


## How it works

This is just the execution of an Ansible playbook in the context of the Openshift project. The action can be `provision` or `deprovision`

The entry point is the [`tasks/main.yml`](./tasks/main.yml) file. It basically iterate over rules that render files in the `templates` directory and pass them to the kubernetes clients.

Default values for variables can be found in [`defaults/main.yml`](./defaults/main.yml)

We do not hard code names of resource in the templates. We rather define them as variable in [`vars/main.yml`](./vars/main.yml) so that it can be referenced from other places/resources.


