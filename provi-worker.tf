resource "null_resource" "ubuntu-worker" {

    connection {
      type                = "ssh"
      user                = var.ssh_username
      host                = var.ips-worker
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
    destination = "/tmp/init-worker.sh"
    content = file("${path.module}/scripts/init-worker.sh")
  }

   provisioner "file" {
    destination = "/tmp/id_rsa"
    content = file("~/.ssh/id_rsa")
  }

   provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /tmp/init-worker.sh",
      "sudo echo '${var.ips-master} k8sm' | sudo tee -a /etc/hosts",
      "/tmp/init-worker.sh"
    ]
  }
  depends_on = [null_resource.ubuntu-master]  
}