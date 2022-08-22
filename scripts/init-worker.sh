#!/bin/bash
sudo chmod 600 /tmp/id_rsa # we will use same key from machine where libvirt is running
a=$(ssh -o StrictHostKeyChecking=no -i /tmp/id_rsa 10.10.7.11 openssl x509 -pubkey \
-in /etc/kubernetes/pki/ca.crt | openssl rsa \
-pubin -outform der 2>/dev/null | openssl dgst \
-sha256 -hex | sed 's/ˆ.* //')
sha_256=$(echo ${a: + 9})
token=$((ssh -o StrictHostKeyChecking=no -i /tmp/id_rsa 10.10.7.11 kubeadm token list | grep authentication) |  cut -d ' ' -f1)
echo $sha_256
sudo kubeadm join \
--token ${token} \
k8sm:6443 \
--discovery-token-ca-cert-hash \
sha256:${sha_256}
sudo rm -f /tmp/id_rsa # we don't want our private key on any machine
