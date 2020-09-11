#!/bin/bash

#Gets user principal name (UPN) for the user currently logged in
UPN=$(az ad signed-in-user show --query userPrincipalName -o tsv)

#Create a YAML manifest named basic-azure-ad-binding.yaml
echo "apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: contoso-cluster-admins
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- apiGroup: rbac.authorization.k8s.io
  kind: User
  name: ${UPN}" > basic-azure-ad-binding.yaml

#Create the ClusterRoleBinding
oc apply -f basic-azure-ad-binding.yaml

#Access cluster
az aks get-credentials --resource-group myResourceGroup --name $aksname --overwrite-existing

#get pods should prompt for authentication with AD creds
oc get pods
