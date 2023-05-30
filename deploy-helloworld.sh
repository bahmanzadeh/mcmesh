#!/bin/bash
export CTX_CLUSTER1=cluster1
export CTX_CLUSTER2=cluster2
kubectl create --context="${CTX_CLUSTER1}" namespace sample
kubectl create --context="${CTX_CLUSTER2}" namespace sample
kubectl label --context="${CTX_CLUSTER1}" namespace sample \
    istio-injection=enabled
kubectl label --context="${CTX_CLUSTER2}" namespace sample \
    istio-injection=enabled
sleep 5    
kubectl apply --context="${CTX_CLUSTER1}" \
    -f samples/helloworld/helloworld.yaml \
    -l service=helloworld -n sample
kubectl apply --context="${CTX_CLUSTER2}" \
    -f samples/helloworld/helloworld.yaml \
    -l service=helloworld -n sample
kubectl apply --context="${CTX_CLUSTER1}" \
    -f samples/helloworld/helloworld.yaml \
    -l version=v1 -n sample
sleep 5    
kubectl get pod --context="${CTX_CLUSTER1}" -n sample -l app=helloworld
sleep 5
kubectl apply --context="${CTX_CLUSTER2}" \
    -f samples/helloworld/helloworld.yaml \
    -l version=v2 -n sample
sleep 5
kubectl get pod --context="${CTX_CLUSTER2}" -n sample -l app=helloworld
sleep 5
kubectl apply --context="${CTX_CLUSTER1}" \
    -f samples/sleep/sleep.yaml -n sample
kubectl apply --context="${CTX_CLUSTER2}" \
    -f samples/sleep/sleep.yaml -n sample
sleep 5
kubectl get pod --context="${CTX_CLUSTER1}" -n sample -l app=sleep
sleep 5
kubectl get pod --context="${CTX_CLUSTER2}" -n sample -l app=sleep
# next: Verifying cross-cluster traffics
