#!/bin/bash
sudo kubeadm init --config=/tmp/kubeadm-config.yaml --upload-certs | tee kubeadm-init.out # create cluster and save output for future review
sleep 60
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo cp /tmp/calico.yaml $HOME/
kubectl apply -f $HOME/calico.yaml
