# Terraform - Creating Kubernetes cluster with FluxCD on libvirt

## What this module provides:

- Creates 2 Virtual machines
- Install all necessery components for creating cluster
- Create cluster consisting of one master/cp node and one worker node
- For network stack Calico is used
- Latest version od ingress/Nginx is deployed
- Fluxcd is deployed (it will create private repo on account addedd in variables.tf)

## Tested on Ubuntu 20.04

Image used for creating VMs is [base Ubuntu box] (https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-disk-kvm.img)

## Prerequests

Install libvirt:

```bash
sudo apt update
sudo apt -y install qemu-kvm libvirt-daemon bridge-utils virtinst libvirt-daemon-system
sudo apt -y install virt-top libguestfs-tools libosinfo-bin  qemu-system virt-manager
```

Install Terraform:

```bash
TER_VER=`curl -s https://api.github.com/repos/hashicorp/terraform/releases/latest | grep tag_name | cut -d: -f2 | tr -d \"\,\v | awk '{$1=$1};1'`
wget https://releases.hashicorp.com/terraform/${TER_VER}/terraform_${TER_VER}_linux_amd64.zip
unzip terraform_${TER_VER}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
```

Change variables.tf (network, username, git username and git token with permissions to create and modify repository)

Also private and public keys are needed for user which will run terraform. Generate key with:

```bash
ssh-keygen -t rsa
```

#Create the infrastructure:

```bash
terraform init
terraform plan
terraform apply
```

**NB** if you have errors alike `Could not open '/var/lib/libvirt/images/terraform_example_root.img': Permission denied'` you need to reconfigure libvirt by setting `security_driver = "none"` in `/etc/libvirt/qemu.conf` and restart libvirt with `sudo systemctl restart libvirtd`.


##Destroy the infrastructure:

```bash
terraform destroy -auto-approve
```

# FluxCD

Fluxcd is created using remote-exec provider and flux command, it is much simpler than with kubernetes provider

After deployment is created and github repo is created it can be tested with simple deployment:

upload sample app yaml in monitored folder on repo, after some time sample app will be deployed on cluster

