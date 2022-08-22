data "template_file" "init_config_worker" {
  template = file("${path.module}/templates/cloud_init.tpl") 
  vars = {
      host_name  = var.worker-name
      user_name  = var.ssh_username
  }
}

data "template_cloudinit_config" "init_config_worker" {
  gzip          = false
  base64_encode = false

  # Main cloud-config configuration file.
  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.init_config_worker.rendered
  }

  # part {
  #   content_type = "text/x-shellscript"
  #   content      = "somescript1"
  # }

  # part {
  #   content_type = "text/x-shellscript"
  #   content      = "somescript2"
  # }
}
