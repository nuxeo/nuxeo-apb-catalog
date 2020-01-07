FROM ansibleplaybookbundle/apb-base



ADD playbooks /opt/apb/actions

# Add our role into the ansible roles dir
ADD . /opt/ansible/roles/nuxeo-arender-apb/
ADD . /opt/ansible/roles/nuxeo-arender-rendition-apb/

RUN chmod -R g=u /opt/{ansible,apb}

USER apb 