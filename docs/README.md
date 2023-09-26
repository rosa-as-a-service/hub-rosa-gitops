# Hub ROSA GitOps
This repository hosts all the artefacts required to configure a Hub ROSA instance

## Setup

### Prerequisites
```
ansible-galaxy install -r 1-bootstrap/requirements.yaml
```

### Bootstrap
```
cd 1-bootstrap
ansible-playbook playbook.yml -v --vault-id @prompt
```