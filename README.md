# Terraform - Creating Kubernetes cluster with FluxCD on libvirt

## What this module provides:

- Creates 2 Virtual machines
- Installs all necessery components for creating cluster
- Creates cluster consisting of one master/cp node and one worker node
- For network stack Calico is used
- Latest version of ingress/Nginx is deployed
- Fluxcd is deployed (it will create private repo on account addedd in variables.tf)

## Tested on Ubuntu 20.04

Image used for creating VMs is [base Ubuntu box] (https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-disk-kvm.img)

Image is needed in folder from where terraform is run, it can be downloaded every time, with a change in main.tf, line where is source image.

For provisioning outside from linux box uri in main.tf should be changed in something like:

uri   = "qemu+ssh://root@ip_address/system"

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

**permission errors** if you have errors alike `Could not open '/var/lib/libvirt/images/terraform_example_root.img': Permission denied'` you need to reconfigure libvirt by setting `security_driver = "none"` in `/etc/libvirt/qemu.conf` and restart libvirt with `sudo systemctl restart libvirtd`.


##Destroy the infrastructure:

```bash
terraform destroy -auto-approve
```

# FluxCD

Fluxcd is created using remote-exec provider and flux command, kubernetes provider is not used and flux command is available on cp node for watching logs etc.

After deployment is created and github repo is created it can be tested with simple deployment:

- upload sample app yaml in monitored folder on repo, after some time sample app will be deployed on cluster

example yaml:

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: hello-world

---

kind: Pod
apiVersion: v1
metadata:
  name: hello-app
  namespace: hello-world
  labels:
    app: hello
spec:
  containers:
    - name: hello-app-name
      image: hashicorp/http-echo
      args:
        - "-text=hello"

---

kind: Service
apiVersion: v1
metadata:
  name: hello-service
  namespace: hello-world
spec:
  selector:
    app: hello
  ports:
    - port: 5678 # Default port for image
    
---

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: helloworld-ingress
  namespace: hello-world
spec:
  ingressClassName: nginx
  rules:
  - http:
      paths:
        - path: /hello
          pathType: Prefix
          backend:
            service:
              name: hello-service
              port:
                number: 5678
```

- or just a sample namespace:

```yaml
---
apiVersion: v1
kind: Namespace
metadata:
  name: best-namespace-ever
```yaml
