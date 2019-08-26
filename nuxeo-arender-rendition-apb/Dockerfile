FROM ansibleplaybookbundle/apb-base

LABEL "com.redhat.apb.spec"=\
"dmVyc2lvbjogMS4wCm5hbWU6IG51eGVvLWFyZW5kZXItcmVuZGl0aW9uLWFwYgpkZXNjcmlwdGlv\
bjogVGhpcyBpcyBhIHNhbXBsZSBhcHBsaWNhdGlvbiBnZW5lcmF0ZWQgYnkgYXBiIGluaXQKYmlu\
ZGFibGU6IEZhbHNlCmFzeW5jOiBvcHRpb25hbAptZXRhZGF0YToKICBkaXNwbGF5TmFtZTogbnV4\
ZW8tYXJlbmRlci1yZW5kaXRpb24KICBkZXBlbmRlbmNpZXM6IFtdCnBsYW5zOgogIC0gbmFtZTog\
ZGVmYXVsdAogICAgZGVzY3JpcHRpb246IFRoaXMgZGVmYXVsdCBwbGFuIGRlcGxveXMgbnV4ZW8t\
YXJlbmRlci1yZW5kaXRpb24tYXBiCiAgICBmcmVlOiBUcnVlCiAgICBtZXRhZGF0YToge30KICAg\
IHBhcmFtZXRlcnM6IFtd"


ADD playbooks /opt/apb/actions

# Add our role into the ansible roles dir
ADD . /opt/ansible/roles/nuxeo-arender-rendition-apb/

RUN chmod -R g=u /opt/{ansible,apb}

USER apb
