# Changelog

## [Unreleased] - 2026-03-19

### Architecture
- Migrated spoke GitOps from **push-based** (hub ArgoCD → spoke API) to **pull-based** (spoke ArgoCD ← git)
- Spokes no longer require continuous API connectivity to the hub for GitOps changes
- ACM retains spoke Application visibility via `managed-serviceaccount` addon and `GitopsService` registration
- Removed `GitOpsCluster`, `Placement`, and `ManagedClusterSetBinding` that powered the push model

### Environments
- Created `production` and `development` environments, replacing the `demo` environment
- Both environments deploy a lean set of hub operators: ACM, AAP, ACK-S3
- Removed non-essential operators from default deployment: Elasticsearch, Logging, Loki, Cert Manager, Quay, RHACS
- All operator definitions remain in `3-operators/` for opt-in use per environment
- Added `spoke/` directories to both environments for spoke-side operator configuration

### Operator Uplifts
- Advanced Cluster Management: `release-2.8` → `release-2.16`
- Klusterlet: `stable-2.3` → `stable` (package name corrected from `klusterlet-product` to `klusterlet`)
- Ansible Automation Platform: `stable-2.4` → `stable-2.6`
- Red Hat ACS: `stable` → `rhacs-4.10`
- Quay: `stable-3.9` → `stable-3.16`
- Cert Manager: `stable-v1` → `stable-v1.18`
- Cluster Logging: `stable` (CLO v5, `logging.openshift.io/v1`) → `stable-6.4` (CLO v6, `observability.openshift.io/v1`)

### Logging Stack Replacement
- Removed deprecated Elasticsearch operator
- Added Loki operator (`stable-6.4`) with S3-backed LokiStack
- Rewrote `ClusterLogging` + `ClusterLogForwarder` v1 to `ClusterLogForwarder` `observability.openshift.io/v1`
- Updated spoke logging overlay for new API

### RHACS
- Updated Central CR from legacy `scanner` to Scanner V4 (`scannerV4` with indexer/matcher)

### Policies
- Added `4-policies/spoke-gitops/` policy set:
  - `policy-spoke-gitops-operator` — deploys OpenShift GitOps + RBAC + `GitopsService` on spokes
  - `policy-spoke-gitops-bootstrap` — deploys bootstrap ArgoCD Application on spokes (depends on operator policy)
  - `policy-spoke-gitops-acm-integration` — enables `managed-serviceaccount` addon on hub for spoke visibility

### Kustomize Fixes
- Replaced deprecated `bases:` with `resources:` across all overlays
- Replaced deprecated `patchesJson6902:` with `patches:` across all overlays

### Bootstrap
- Updated default ArgoCD Application path from `2-environments/demo/hub` to `2-environments/production/hub`

---

## Historical Changes (pre-uplift)

Reconstructed from git history (`b9c73a6..ae0fe98`, 2023).

### Spoke Management
- Migrated spoke GitOps from individual Applications to `ApplicationSet` with ACM `clusterDecisionResource` generator
- Added `GitOpsCluster` + `Placement` for ACM-managed ArgoCD cluster registration
- Added spoke `ApplicationSet` definitions for logging, elasticsearch, and misc configurations

### Operators Added
- Advanced Cluster Management (ACM) with `MultiClusterHub` and `MultiClusterObservability`
- Red Hat Advanced Cluster Security (RHACS) with Central and Scanner
- Ansible Automation Platform (AAP) with Controller
- OpenShift Cert Manager with Let's Encrypt ClusterIssuer and Route53 DNS01 solver
- OpenShift Logging with Elasticsearch backend and CloudWatch forwarding
- Quay Registry (all-managed components)
- AWS ACK S3 Controller
- OpenShift Data Foundation (later removed in favour of ACK S3)

### Policies
- Added OpenShift Plus policy set (RHACS sensor, compliance operator, e8 scan)
- Added subscription-admin hub policy

### Infrastructure
- Ansible bootstrap playbook for initial ArgoCD deployment and secret management
- Hub and spoke custom branding and console banners
- Cert Manager Route53 integration for automatic TLS certificates
