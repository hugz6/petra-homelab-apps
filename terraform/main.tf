# main.tf - Configuration avec provider BPG pour Proxmox VE 8/9
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.66.0"  # Version stable récente
    }
  }
}

provider "proxmox" {
  endpoint  = var.proxmox_api_url
  api_token = "${var.proxmox_api_token_id}=${var.proxmox_api_token_secret}"
  insecure  = true  # Pour les certificats auto-signés
  
  # Alternative avec authentification par mot de passe :
  # username = var.proxmox_username  # ex: "root@pam"
  # password = var.proxmox_password
}

# Ressource pour les masters Kubernetes
resource "proxmox_virtual_environment_vm" "k8s_masters" {
  count = var.master_count

  vm_id       = var.vm_start_id + count.index
  name        = "k8s-master-${count.index + 1}"
  description = "Kubernetes Master Node"
  tags        = ["kubernetes", "master"]
  node_name   = var.proxmox_nodes[count.index % length(var.proxmox_nodes)]
  
  # Configuration générale
  started = true
  on_boot = true
  
  # Ressources CPU/RAM
  cpu {
    cores   = var.master_cores
    sockets = 1
    type    = "x86-64-v2-AES"
  }
  
  memory {
    dedicated = var.master_memory
  }

  # Agent QEMU
  agent {
    enabled = true
    trim    = true
    type    = "virtio"
  }

  # Disque système
  disk {
    datastore_id = "local-lvm"
    file_id      = var.template_name  # Template/clone source
    interface    = "scsi0"
    size         = var.master_disk_size
    ssd          = true
    discard      = "on"
  }

  # Configuration réseau
  network_device {
    bridge  = var.vm_bridge
    model   = "virtio"
    vlan_id = var.vlan_id  # Optionnel
  }

  # Configuration Cloud-Init
  initialization {
    datastore_id = "local-lvm"
    
    ip_config {
      ipv4 {
        address = "${cidrhost(var.network_cidr, var.ip_start_index + count.index)}/${split("/", var.network_cidr)[1]}"
        gateway = var.network_gateway
      }
    }
    
    dns {
      servers = var.network_dns_servers
    }
    
    user_account {
      username = var.vm_user
      password = var.vm_password
      keys     = [var.ssh_public_key]
    }
    
    user_data_file_id = var.cloud_init_user_data_file_id  # Optionnel
  }
  
  # Clonage depuis template (ID dépend du nœud)
  clone {
    vm_id = var.proxmox_nodes[count.index % length(var.proxmox_nodes)] == "pve-1" ? var.template_vm_id_pve1 : var.template_vm_id_pve2
    full  = true
  }
}

# Ressource pour les workers Kubernetes
resource "proxmox_virtual_environment_vm" "k8s_workers" {
  count      = var.worker_count
  depends_on = [proxmox_virtual_environment_vm.k8s_masters]

  vm_id       = var.vm_start_id + var.master_count + count.index
  name        = "k8s-worker-${count.index + 1}"
  description = "Kubernetes Worker Node"
  tags        = ["kubernetes", "worker"]
  node_name   = var.proxmox_nodes[(var.master_count + count.index) % length(var.proxmox_nodes)]
  
  # Configuration générale
  started = true
  on_boot = true
  
  # Ressources CPU/RAM
  cpu {
    cores   = var.worker_cores
    sockets = 1
    type    = "x86-64-v2-AES"
  }
  
  memory {
    dedicated = var.worker_memory
  }

  # Agent QEMU
  agent {
    enabled = true
    trim    = true
    type    = "virtio"
  }

  # Disque système
  disk {
    datastore_id = "local-lvm"
    file_id      = var.template_name
    interface    = "scsi0"
    size         = var.worker_disk_size
    ssd          = true
    discard      = "on"
  }

  # Configuration réseau
  network_device {
    bridge  = var.vm_bridge
    model   = "virtio"
    vlan_id = var.vlan_id  # Optionnel
  }

  # Configuration Cloud-Init
  initialization {
    datastore_id = "local-lvm"
    
    ip_config {
      ipv4 {
        address = "${cidrhost(var.network_cidr, var.ip_start_index + var.master_count + count.index)}/${split("/", var.network_cidr)[1]}"
        gateway = var.network_gateway
      }
    }
    
    dns {
      servers = var.network_dns_servers
    }
    
    user_account {
      username = var.vm_user
      password = var.vm_password
      keys     = [var.ssh_public_key]
    }
  }
  
  # Clonage depuis template (ID dépend du nœud)
  clone {
    vm_id = var.proxmox_nodes[(var.master_count + count.index) % length(var.proxmox_nodes)] == "pve-1" ? var.template_vm_id_pve1 : var.template_vm_id_pve2
    full  = true
  }
}

# Outputs
output "master_ips" {
  description = "IP addresses of Kubernetes master nodes"
  value = {
    for vm in proxmox_virtual_environment_vm.k8s_masters :
    vm.name => cidrhost(var.network_cidr, var.ip_start_index + index(proxmox_virtual_environment_vm.k8s_masters, vm))
  }
  sensitive = true
}

output "worker_ips" {
  description = "IP addresses of Kubernetes worker nodes"
  value = {
    for vm in proxmox_virtual_environment_vm.k8s_workers :
    vm.name => cidrhost(var.network_cidr, var.ip_start_index + var.master_count + index(proxmox_virtual_environment_vm.k8s_workers, vm))
  }
  sensitive = true
}

output "master_vm_ids" {
  description = "VM IDs of master nodes"
  value = proxmox_virtual_environment_vm.k8s_masters[*].vm_id
}

output "worker_vm_ids" {
  description = "VM IDs of worker nodes"  
  value = proxmox_virtual_environment_vm.k8s_workers[*].vm_id
}
