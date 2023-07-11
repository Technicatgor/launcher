variable "cloudinit_template_name" {
  type = string
}

variable "proxmox_node" {
  type = string
}

variable "ssh_key" {
  type      = string
  sensitive = true
}

resource "proxmox_vm_qemu" "k8s-1" {
  count       = 1
  name        = "k8s-0${count.index + 1}"
  vmid        = "100${count.index + 1}"
  target_node = var.proxmox_node
  clone       = var.cloudinit_template_name
  agent       = 1
  os_type     = "cloud-init"
  cores       = 2
  sockets     = 1
  cpu         = "host"
  memory      = 2048
  balloon     = 1024
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"

  disk {
    slot    = 0
    size    = "20G"
    type    = "scsi"
    storage = "local"
  }

  network {
    model  = "virtio"
    bridge = "vmbr1"
  }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0  = "ip=10.0.50.20${count.index + 1}/24,gw=10.0.50.1"
  nameserver = "10.0.50.77"

  sshkeys = <<EOF
  ${var.ssh_key}
  EOF

}
