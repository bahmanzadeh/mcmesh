#!/bin/bash 
export CTX_CLUSTER1=cluster1
export CTX_CLUSTER2=cluster2
# Access from istiod in cluster1 to api-server in cluster2 using service account
kubectl create sa istiod-service-account -n istio-system --context="${CTX_CLUSTER1}"
istioctl x create-remote-secret \
  --context="${CTX_CLUSTER2}" \
  --type=config \
  --namespace=istio-system \
  --service-account=istiod \
  --create-service-account=false | \
kubectl apply -f - --context="${CTX_CLUSTER1}"
