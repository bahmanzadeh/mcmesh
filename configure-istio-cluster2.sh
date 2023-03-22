#!/bin/bash
kubectl config use-context cluster2
kubectl --context="${CTX_CLUSTER2}" create namespace istio-system
kubectl --context="${CTX_CLUSTER2}" annotate namespace istio-system topology.istio.io/controlPlaneClusters=cluster1 --overwrite
kubectl --context="${CTX_CLUSTER2}" label namespace istio-system topology.istio.io/network=network2 --overwrite
# export DISCOVERY_ADDRESS=$(kubectl \
#     --context="${CTX_CLUSTER1}" \
#     -n istio-system get svc istio-eastwestgateway \
#     -o jsonpath='{.status.loadBalancer.ingress[0].ip}') 
istioctl install --context="${CTX_CLUSTER2}" -f cluster2.yaml -y
sleep 5
istioctl x create-remote-secret --context="${CTX_CLUSTER2}" -n istio-system --name=cluster2 | \
    kubectl apply -f - --context="${CTX_CLUSTER1}"
samples/multicluster/gen-eastwest-gateway.sh \
    --mesh mesh1 --cluster cluster2 --network network2 | \
    istioctl --context="${CTX_CLUSTER2}" install -y -f -
sleep 5
kubectl --context="${CTX_CLUSTER2}" get svc istio-eastwestgateway -n istio-system
kubectl --context="${CTX_CLUSTER2}" apply -n istio-system -f \
    samples/multicluster/expose-services.yaml


