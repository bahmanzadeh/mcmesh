#!/bin/bash
kubectl config use-context cluster1
istioctl uninstall --purge -y
kubectl delete ns istio-system 
kubectl config use-context cluster2
istioctl uninstall --purge -y
kubectl delete ns istio-system 
kubectl config use-context cluster1
