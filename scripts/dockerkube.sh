#!/bin/bash
sudo echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt update
sudo apt -y install - docker.io bash-completion qemu-guest-agent kubeadm=1.22.1-00 kubelet=1.22.1-00 kubectl=1.22.1-00
sudo apt-mark hold kubelet kubeadm kubectl #disabling auto upgrades
sudo cp /tmp/daemon.json /etc/docker/ #Changing docker storage driver
sudo systemctl restart docker
until [ $(systemctl is-active docker) == "active" ]
do
    sleep 5
done
