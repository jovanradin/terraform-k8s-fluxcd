resource "null_resource" "ubuntu-master-fluxcd" {

    connection {
      type                = "ssh"
      user                = var.ssh_username
      host                = var.ips-master
      private_key         = file("~/.ssh/id_rsa")
      timeout             = "2m"
    }

  provisioner "file" {
    destination = "/tmp/ingress.yaml"
    content = file("${path.module}/scripts/ingress.yaml")
  }

  provisioner "remote-exec" {
    inline = [
      "curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash",
      "helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx",
      "helm upgrade --install ingress-nginx --namespace ingress-nginx ingress-nginx/ingress-nginx --create-namespace --values /tmp/ingress.yaml",
      "curl -s https://fluxcd.io/install.sh | sudo bash",
      "export GITHUB_TOKEN=${var.git_token} ; flux bootstrap github --owner=${var.git_user} --repository=${var.flux_repo_name} --path=.${var.flux_path} --personal"
    ]

  }

  depends_on = [null_resource.ubuntu-worker]
    
}
