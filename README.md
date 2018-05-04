# Ansible Playbook Bundle collection for Nuxeo

This repository contains several APB designed to deploy the service needed by Nuxeo in platform that support Ansible Service Broker. 

Those APB are pushed in the [Nuxeo APB](https://hub.docker.com/r/nuxeoapb/) organization in DockerHub.

To activate them, simply add the following snippet in the Ansible Service Broker configuration:

```
registry:
 - type: dockerhub
    name: nuxeo-apb
    url:  
    org:  nuxeoapb
    tag:  latest
    white_list:
     - ".*-apb$"

    auth_type: ""
    auth_name: ""
```

# Licensing

Most of the source code in the Nuxeo Platform is copyright Nuxeo and
contributors, and licensed under the Apache License, Version 2.0.

See [/licenses](/licenses) and the documentation page [Licenses](http://doc.nuxeo.com/x/gIK7) for details.

# About Nuxeo

Nuxeo dramatically improves how content-based applications are built, managed and deployed, making customers more agile, innovative and successful. Nuxeo provides a next generation, enterprise ready platform for building traditional and cutting-edge content oriented applications. Combining a powerful application development environment with SaaS-based tools and a modular architecture, the Nuxeo Platform and Products provide clear business value to some of the most recognizable brands including Verizon, Electronic Arts, Sharp, FICO, the U.S. Navy, and Boeing. Nuxeo is headquartered in New York and Paris. More information is available at [www.nuxeo.com](http://www.nuxeo.com).


