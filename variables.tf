variable "poolpath" {
  type = string
  default = "/kvm/pools/terraform-provider-libvirt-pool-k8s"
}
variable "master-dsk-size" {
type = string
  default = "17179869184"
}
variable "worker-dsk-size" {
type = string
  default = "25769803776"
}
variable "memory-master" {
  type = string
  default = "2048"
}
variable "memory-worker" {
  type = string
  default = "4096"
}
variable "vcpu-master" {
  type = number
  default = 2
}
variable "vcpu-worker" {
  type = number
  default = 4
}
variable "master-name" {
  type = string
  default = "ubuntu-master"
}
variable "worker-name" {
  type = string
  default = "ubuntu-worker"
}
variable "ips-master" {
  type = string
  default = "10.10.7.11"
}
variable "ips-worker" {
  type = string
  default = "10.10.7.22"
}
variable "ssh_username" {
  type = string
  default = "sc"
}
variable "flux_repo_name" {
  type = string
  default = "flux-cwire"
}
variable "flux_path" {
  type = string
  default = "/clusters/my-cluster"
}
variable "git_user" {
  type = string
  default = "username"
}
variable "git_token" {
  type = string
  default = "ghp_token"
}




