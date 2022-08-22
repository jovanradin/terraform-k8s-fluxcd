#!/bin/bash
sudo kubeadm init --config=/tmp/kubeadm-config.yaml --upload-certs | tee kubeadm-init.out # Save output for future review
sleep 60
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
sudo cp /tmp/calico.yaml $HOME/
kubectl apply -f $HOME/calico.yaml
# helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
# helm upgrade --install ingress-nginx --namespace ingress-nginx ingress-nginx/ingress-nginx --create-namespace --values /tmp/ingress.yaml