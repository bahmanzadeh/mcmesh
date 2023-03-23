#!/bin/bash
export CTX_CLUSTER1=cluster1
export CTX_CLUSTER2=cluster2
kubectl config use-context cluster2
kubectl create ns istio-system 
kubectl --context="${CTX_CLUSTER2}" get namespace istio-system && \
  kubectl --context="${CTX_CLUSTER2}" label namespace istio-system topology.istio.io/network=network2
istioctl install --context="${CTX_CLUSTER2}" -f cluster2.yaml -y
sleep 5
samples/multicluster/gen-eastwest-gateway.sh \
    --mesh mesh1 --cluster cluster2 --network network2 | \
    istioctl --context="${CTX_CLUSTER2}" install -y -f -
sleep 5
kubectl --context="${CTX_CLUSTER2}" get svc istio-eastwestgateway -n istio-system
kubectl --context="${CTX_CLUSTER2}" apply -n istio-system -f \
    samples/multicluster/expose-services.yaml
