#!/bin/bash
#run it only onetime
# This process is going to issue an intermidate CA certificate for each cluster and save it in a secret
# First it will create a root CA and then it will ceate a intermidate CA cert signed by that for each cluster.
# for mTLS each workload needs a certificate and Istio control plane (Istiod) as the Certificate Manager will issue the certs by default. 
# if you have multiple istiod then you need all control planes to have the same root CA to be able to trust each other in an multi cluster mesh.
# A multicluster service mesh deployment requires that you establish trust between all clusters in the mesh. 
# You need to first create these certs and have them available. note Changing the CA typically requires reinstalling Istio. 
# after running this file you can go ahead and install the istio on the clusters. It will read these certs from the secret in istio-system namespace.
# https://istio.io/latest/docs/tasks/security/cert-management/plugin-ca-cert/
# run it this way : . ./<filename>
mkdir -p certs
pushd certs
make -f ../tools/certs/Makefile.selfsigned.mk root-ca
make -f ../tools/certs/Makefile.selfsigned.mk cluster1-cacerts
make -f ../tools/certs/Makefile.selfsigned.mk cluster2-cacerts
# for cluster 1:
kubectl config use-context cluster1
kubectl create ns istio-system 
kubectl create secret generic cacerts -n istio-system \
      --from-file=cluster1/ca-cert.pem \
      --from-file=cluster1/ca-key.pem \
      --from-file=cluster1/root-cert.pem \
      --from-file=cluster1/cert-chain.pem
# for cluster 2:      
kubectl config use-context cluster2
kubectl create ns istio-system 
kubectl create secret generic cacerts -n istio-system \
      --from-file=cluster2/ca-cert.pem \
      --from-file=cluster2/ca-key.pem \
      --from-file=cluster2/root-cert.pem \
      --from-file=cluster2/cert-chain.pem
popd
