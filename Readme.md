Requirements
- Istio deploymet model: Multi Primary multi cluster single mesh with different networks
- We need two clusters with load balance installed
- Istio can be or not installed on both clusters. The scripts will install Istio anyways.
- First you need to change the root CA since this is a multi primary multi cluster and you need to have root CA and then create an intermiate CA from the root for each cluster
Order of running the scripts:
install-selfsigned-cert-plugin.sh
install-istio-multi-primary-cluster1.sh
install-istio-multi-primary-cluster2.sh
enable-endpoint-discovery.sh

kubectl label namespace ns1 istio-injection=enabled

then deploy svc1 in ns1 in both clusters (ns1 is extended between two clusters). 
v1 in cluster1
v2 in cluster2
then you will loadbalance between them and you will know which cluster you are hitting

run this service in ns1 in both clusters:

kubectl run mypod1 --context cluster1 --image=rezabah/netutils:1.0 -n ns1 -l mylabel=mypod1 -i --tty -- /bin/bash
kubectl run mypod2 --context cluster2 --image=rezabah/netutils:1.0 -n ns2 -l mylabel=mypod2 -i --tty -- /bin/bash
attach to the container if it has tty :
kubectl attach -it tenantns1-svc -n ns1

#kubectl rollout restart deploy -n ns1

Curl in loop:
for ((i=1;i<=10;i++)); do curl helloworld-svc1.ns1; done | grep SVC1
from outside:
for ((i=1;i<=10;i++)); do curl http://ns1.helloworld.com/svc1; done | grep SVC1
for ((i=1;i<=10;i++)); do curl http://ns2.helloworld.com/svc1; done | grep SVC1





