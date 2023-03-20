#!/bin/bash
export CTX_CLUSTER1=cluster1
export CTX_CLUSTER2=cluster2
kubectl config use-context cluster1
istioctl install --set profile=demo -y
sleep 5
kubectl --context="${CTX_CLUSTER1}" get namespace istio-system && \
  kubectl --context="${CTX_CLUSTER1}" label namespace istio-system topology.istio.io/network=network1
istioctl install --set values.pilot.env.EXTERNAL_ISTIOD=true --context="${CTX_CLUSTER1}" -f cluster1.yaml -y
sleep 5
samples/multicluster/gen-eastwest-gateway.sh \
    --mesh mesh1 --cluster cluster1 --network network1 | \
    istioctl --context="${CTX_CLUSTER1}" install -y -f -
sleep 5
# wait and check if you see the external IP address
kubectl --context="${CTX_CLUSTER1}" get svc istio-eastwestgateway -n istio-system
sleep 5
kubectl apply --context="${CTX_CLUSTER1}" -n istio-system -f \
    samples/multicluster/expose-istiod.yaml
kubectl --context="${CTX_CLUSTER1}" apply -n istio-system -f \
    samples/multicluster/expose-services.yaml
