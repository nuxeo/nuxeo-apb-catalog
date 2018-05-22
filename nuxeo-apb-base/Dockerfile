FROM ansibleplaybookbundle/apb-base

RUN yum install -y openssl && yum clean all

ADD requirements.yml /opt/apb/actions/requirements.yml
ADD run_role_on_localhost.yml /opt/apb/actions/run_role_on_localhost.yml

RUN ansible-galaxy install -r /opt/apb/actions/requirements.yml && \
    ansible-playbook /opt/apb/actions/run_role_on_localhost.yml -e "ROLE=andrewrothstein.cfssl"
