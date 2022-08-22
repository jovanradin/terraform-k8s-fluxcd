#null_resource is used for sending files and running scripts an commands on remote machines
resource "null_resource" "ubuntu-master" {

    connection {
      type                = "ssh"
      user                = var.ssh_username
      host                = var.ips-master
      private_key         = file("~/.ssh/id_rsa")
      timeout             = "2m"
    }

  provisioner "file" {
    destination = "/tmp/dockerkube.sh"
    content = file("${path.module}/scripts/dockerkube.sh")
  }

  provisioner "file" {
    destination = "/tmp/daemon.json"
    content = file("${path.module}/scripts/daemon.json")
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/dockerkube.sh",
      "/tmp/dockerkube.sh"
    ]
  }

  provisioner "file" {
    destination = "/tmp/calico.yaml"   #downloaded from https://docs.projectcalico.org/manifests/calico.yaml without changes
    content = file("${path.module}/scripts/calico.yaml")
  }

  provisioner "file" {
    destination = "/tmp/kubeadm-config.yaml"
    content = file("${path.module}/scripts/kubeadm-config.yaml")
  }

  provisioner "file" {
    destination = "/tmp/init-master.sh"
    content = file("${path.module}/scripts/init-master.sh")
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/init-master.sh",
      "sudo echo '${var.ips-master} k8sm' | sudo tee -a /etc/hosts",
      "/tmp/init-master.sh"
    ]
  }  
}


