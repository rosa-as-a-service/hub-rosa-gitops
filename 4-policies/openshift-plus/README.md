# OpenShift Plus PolicySet - customised for ROSA Spoke deployments

This is an ACM policy set used to deploy ROSA spoke components (RHACS Secured Cluster Services and the Compliance Operator). It's derived from the upstream [openshift-plus policy set](https://github.com/open-cluster-management-io/policy-collection/tree/main/policygenerator/policy-sets/stable/openshift-plus).

## Prerequisites
 To install the customised OpenShift Plus using this PolicySet, you must first have:
 - Currently this PolicySet is tested for AWS only. Extending the PolicySet to other environments should be straightforward.
 - A supported version of Red Hat OpenShift Container Platform 
 - An install of Red Hat Advanced Cluster Management for Kubernetes version 2.7 or newer.
   - Follow the document [Requirements and Recommendations] for Red Hat Advanced Cluster Management for Kubernetes(https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.7/html/install/installing#requirements-and-recommendations)
  

## Installation

The Advanced Cluster Security Secured Cluster Services and the Compliance Operator are deployed onto all OpenShift managed clusters.

Prior to applying the `PolicySet`, perform these steps:

1. Create two cluster sets in ACM:
- One cluster set should be named `spokes` and contain the spoke clusters
- The other cluster set should be named `hub` and contain the hub 

2. Ensure that the ACS Central components have deployed successfully to the `acs-instance` namespace on the hub cluster (via ArgoCD), and create the `policies` namespace on the hub:
```
oc new-project policies
```

3. To allow for subscriptions to be applied below you must apply and set to enforce the policy [policy-configure-subscription-admin-hub.yaml](https://github.com/open-cluster-management-io/policy-collection/blob/main/community/CM-Configuration-Management/policy-configure-subscription-admin-hub.yaml). Create this file:
```
oc create -f policy-configure-subscription-admin-hub.yaml
```
4. Install the Policy generator Kustomize plugin by following the [installation instructions](https://github.com/stolostron/policy-generator-plugin#installation). It is recommended to use Kustomize v4.5+.

5. Policies are installed to the `policies` namespace.  Make sure the placement bindings match this namespace for the hub and other managed clusters.
   Example yaml to apply a ManagedClusterSetBinding for the policies namespace.
    ```yaml
    apiVersion: cluster.open-cluster-management.io/v1beta2
    kind: ManagedClusterSetBinding
    metadata:
        name: spokes
        namespace: policies
    spec:
        clusterSet: spokes
    ---
    apiVersion: cluster.open-cluster-management.io/v1beta2
    kind: ManagedClusterSetBinding
    metadata:
        name: hub
        namespace: policies
    spec:
        clusterSet: hub
    ```
    ```bash
    oc apply -f managed-cluster.yaml 
    ```

6. Finally, apply the policies into the `policies` namespace:
```
kustomize build --enable-alpha-plugins  | oc apply -n policies -f -
```