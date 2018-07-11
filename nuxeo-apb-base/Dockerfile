FROM ansibleplaybookbundle/apb-base:sprint150

RUN yum install -y openssl java-1.8.0-openjdk httpd-tools && yum clean all

ADD requirements.yml /opt/apb/actions/requirements.yml
ADD run_role_on_localhost.yml /opt/apb/actions/run_role_on_localhost.yml

RUN ansible-galaxy install -r /opt/apb/actions/requirements.yml && \
    ansible-playbook /opt/apb/actions/run_role_on_localhost.yml -e "ROLE=andrewrothstein.cfssl"
