# We fetch the latest ubuntu release image from their mirrors
resource "libvirt_volume" "ubuntu-master-qcow2" {
  name   = "ubuntu-qcow2-master"
  pool   = "k8spool"
  base_volume_id = "${libvirt_volume.base.id}"
  format = "qcow2"
  size   = var.master-dsk-size
}

# for more info about paramater check this out
# https://github.com/dmacvicar/terraform-provider-libvirt/blob/master/website/docs/r/cloudinit.html.markdown
# Use CloudInit to add our ssh-key to the instance
# you can add also meta_data field
resource "libvirt_cloudinit_disk" "commoninit-master" {
  name           = "commoninit-master.iso"
  pool           = "k8spool"
  user_data      = data.template_cloudinit_config.init_config.rendered
}

# Create the machine
resource "libvirt_domain" "domain-ubuntu-master" {
  name   = var.master-name
  memory = var.memory-master
  vcpu   = var.vcpu-master

  cloudinit = libvirt_cloudinit_disk.commoninit-master.id

  network_interface {
  #    network_name   = "default"
      network_id     = libvirt_network.test_network.id
      wait_for_lease = true
      hostname       = var.master-name
      addresses      = [var.ips-master]

  }

  # IMPORTANT: this is a known bug on cloud images, since they expect a console
  # we need to pass it
  # https://bugs.launchpad.net/cloud-images/+bug/1573095
  console {
    type        = "pty"
    target_port = "0"
    target_type = "serial"
  }

  console {
    type        = "pty"
    target_type = "virtio"
    target_port = "1"
  }

  disk {
    volume_id = libvirt_volume.ubuntu-master-qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee -a /etc/apt/sources.list.d/kubernetes.list",
  #     "sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -",
  #     "sudo apt update",
  #     "sudo apt -y install kubeadm=1.22.1-00 kubelet=1.22.1-00 kubectl=1.22.1-00",
  #     "sudo apt-mark hold kubelet kubeadm kubectl"
  #   ]

  #   connection {
  #     type                = "ssh"
  #     user                = var.ssh_username
  #     host                = var.ips-master
  #     private_key         = file("~/.ssh/id_rsa")
  #     timeout             = "2m"
  #   }
  # }
}
