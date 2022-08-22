terraform {
 required_version = ">= 0.13"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"  # libvirt provider
    }
  }
}

# initialize the provider
provider "libvirt" {
  uri = "qemu:///system"
  #uri   = "qemu+ssh://user@ip_address/system"
}

# creating the pool from terraform
resource "libvirt_pool" "k8spool" {  
  name = "k8spool"
  type = "dir"
  path = var.poolpath
}

#creating the volume
resource "libvirt_volume" "base" {
  name = "base"
  pool = "k8spool"
  #source = "https://cloud-images.ubuntu.com/focal/current/focal-server-cloudimg-amd64-disk-kvm.img" #uncomment and comment below for direct download of image
  source  = "focal-server-cloudimg-amd64-disk-kvm.img"
  format = "qcow2"
  depends_on = [libvirt_pool.k8spool]  # without this pool will not be created before this step
}

#creating network
resource "libvirt_network" "test_network" {
   name = "test_network"
   mode = "nat"
   addresses = ["10.10.7.0/24"]
   dhcp {
      enabled = false
   }
   dns {
    # (Optional, default false)
    # Set to true, if no other option is specified and you still want to 
    # enable dns.
    enabled = true
    # (Optional, default false)
    # true: DNS requests under this domain will only be resolved by the
    # virtual network's own DNS server
    # false: Unresolved requests will be forwarded to the host's
    # upstream DNS server if the virtual network's DNS server does not
    # have an answer.
    local_only = true

    forwarders {
      address = "8.8.8.8"
    }
   } 
}
