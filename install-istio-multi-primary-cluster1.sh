#!/bin/bash
export CTX_CLUSTER1=cluster1
export CTX_CLUSTER2=cluster2
kubectl config use-context cluster1
#kubectl create ns istio-system 
kubectl --context="${CTX_CLUSTER1}" get namespace istio-system && \
  kubectl --context="${CTX_CLUSTER1}" label namespace istio-system topology.istio.io/network=network1
istioctl install --context="${CTX_CLUSTER1}" -f cluster1.yaml -y
sleep 5
samples/multicluster/gen-eastwest-gateway.sh \
    --mesh mesh1 --cluster cluster1 --network network1 | \
    istioctl --context="${CTX_CLUSTER1}" install -y -f -
sleep 5
kubectl --context="${CTX_CLUSTER1}" get svc istio-eastwestgateway -n istio-system
kubectl --context="${CTX_CLUSTER1}" apply -n istio-system -f \
    samples/multicluster/expose-services.yaml

