#cloud-config

# package_upgrade: false --- scripts are used

# packages: -- scripts are used because of lock on apt process
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



