FROM ansibleplaybookbundle/apb-base

LABEL "com.redhat.apb.spec"=\
"dmVyc2lvbjogMS4wCm5hbWU6IG51eGVvLWFyZW5kZXItcHJldmlld2VyLWFwYgpkZXNjcmlwdGlv\
bjogVGhpcyBpcyBhIHNhbXBsZSBhcHBsaWNhdGlvbiBnZW5lcmF0ZWQgYnkgYXBiIGluaXQKYmlu\
ZGFibGU6IEZhbHNlCmFzeW5jOiBvcHRpb25hbAptZXRhZGF0YToKICBkaXNwbGF5TmFtZTogbnV4\
ZW8tYXJlbmRlci1wcmV2aWV3ZXIKICBkZXBlbmRlbmNpZXM6IFtdCnBsYW5zOgogIC0gbmFtZTog\
ZGVmYXVsdAogICAgZGVzY3JpcHRpb246IFRoaXMgZGVmYXVsdCBwbGFuIGRlcGxveXMgbnV4ZW8t\
YXJlbmRlci1wcmV2aWV3ZXItYXBiCiAgICBmcmVlOiBUcnVlCiAgICBtZXRhZGF0YToge30KICAg\
IHBhcmFtZXRlcnM6IFtd"

ADD playbooks /opt/apb/actions

# Add our role into the ansible roles dir
ADD . /opt/ansible/roles/nuxeo-arender-previewer-apb/

RUN chmod -R g=u /opt/{ansible,apb}

USER apb

#COPY playbooks /opt/apb/actions
#COPY roles /opt/ansible/roles
#RUN chmod -R g=u /opt/{ansible,apb}
#USER apb
