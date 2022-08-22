# Created volume for worker
resource "libvirt_volume" "ubuntu-worker-qcow2" {
  name   = "ubuntu-qcow2-worker"
  pool   = "k8spool"
  base_volume_id = "${libvirt_volume.base.id}"
  format = "qcow2"
  size   = var.worker-dsk-size
}

# cloudinit with data template

resource "libvirt_cloudinit_disk" "commoninit-worker" {
  name           = "commoninit-worker.iso"
  pool           = "k8spool"
  user_data      = data.template_cloudinit_config.init_config_worker.rendered
}

# Create the machine
resource "libvirt_domain" "domain-ubuntu-worker" {
  name   = var.worker-name
  memory = var.memory-worker
  vcpu   = var.vcpu-worker

  cloudinit = libvirt_cloudinit_disk.commoninit-worker.id

  network_interface {

      network_id     = libvirt_network.test_network.id
      wait_for_lease = true
      hostname       = var.worker-name
      addresses      = [var.ips-worker]
  
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
    volume_id = libvirt_volume.ubuntu-worker-qcow2.id
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }

}
