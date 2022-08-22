#cloud-config
# vim: syntax=yaml
#
# ***********************
# 	---- for more examples look at: ------
# ---> https://cloudinit.readthedocs.io/en/latest/topics/examples.html
# ******************************
#
# This is the configuration syntax that the write_files module
# will know how to understand. encoding can be given b64 or gzip or (gz+b64).
# The content will be decoded accordingly and then written to the path that is
# provided.
#
# Note: Content strings here are truncated for example purposes.
# package_upgrade: false

# packages:
#  - docker.io
#  - bash-completion
#  - qemu-guest-agent

hostname: ${host_name}
manage_etc_hosts: true
ssh_pwauth: True

users:
  - name: ${user_name} # Change me
    ssh_authorized_keys: ${file("~/.ssh/id_rsa.pub")}
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    shell: /bin/bash
    groups: wheel

# runcmd: 
#    - [ sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - ]
#    - [ sudo apt install kubeadm=1.22.1-00 kubelet=1.22.1-00 kubectl=1.22.1-00 ]


