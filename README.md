# hub-rosa-gitops

All the components required to configure a hub ROSA instance

## Authors

- @ahussey-redhat
- @shaneboulden
- @joelapatatechaude
- @nreilly-rhn 
- @snowjet

## Setup

Please read the [bootstrap README](./1-bootstrap/README.md) to setup the environment.

## Overview

ROSA-as-a-Service uses a hub and spoke architecture.
The central `hub` is has all of the shared services required to provision the `spoke`s.

The `hub` also monitors the `spoke`s health and compliance using Red Hat Advanced Cluster Manager for Kubernets and Red Hat Advanced Cluster Security for Kubernetes.

The `spoke`s have a baseline configuration applied, but gives the freedom and power to the end user for any further configuration.

```mermaid
---
title: Top Down View
---
flowchart TD;
    hub(ROSA)
    spoke1(ROSA)
    spoke2(ROSA)
    spoke3(ROSA)
    spoke4(ROSA)
    spoke5(ROSA)

    subgraph HUB
    hub
    end

    subgraph Spoke 1
    spoke1
    end
    hub<-- PrivateLink -->spoke1

    subgraph Spoke 2
    spoke2
    end
    hub<-- PrivateLink -->spoke2

    subgraph Spoke 3
    spoke3
    end
    hub<-- PrivateLink -->spoke3

    subgraph Spoke 4
    spoke4
    end
    hub<-- PrivateLink -->spoke4

    subgraph Spoke 5
    spoke5
    end
    hub<-- PrivateLink -->spoke5
```

## Contributing

Please read the [CONTRIBUTE](./CONTRIBUTE.md) document if you'd like to contribute to this project.


