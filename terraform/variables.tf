# Proxmox setup
variable "proxmox_api_url" {
  description = "PROXMOX API's URL"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "Proxmox token id (ex: terraform-prov@pve!mytoken)"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "Token Secret Proxmox"
  type        = string
  sensitive   = true
}

# Alternative: password auth
variable "proxmox_username" {
  description = "Proxmox username (ex: root@pam)"
  type        = string
  default     = null
}

variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  default     = null
  sensitive   = true
}

variable "proxmox_nodes" {
  description = "List of proxmox nodes"
  type        = list(string)
  default     = ["pve-1", "pve-2"]
}

# Templates/clones config
variable "template_name" {
  description = "Template name to clone"
  type        = string
}

variable "template_vm_id_pve1" {
  description = "Template VM id on pve-1"
  type        = number
  default     = 9000
}

variable "template_vm_id_pve2" {
  description = "Template VM id on pve-2"
  type        = number
  default     = 9001
}

# VMs config
variable "vm_start_id" {
  description = "Start range ID for VMs"
  type        = number
  default     = 1000
}

variable "master_count" {
  description = "Number of Kubernetes masters"
  type        = number
  default     = 3
}

variable "worker_count" {
  description = "Number of Kubernetes workers"
  type        = number
  default     = 3
}

# VM Ressources for Masters
variable "master_cores" {
  description = "Number of CPU for masters"
  type        = number
  default     = 2
}

variable "master_memory" {
  description = "Memory for masters (in Mb)"
  type        = number
  default     = 4096
}

variable "master_disk_size" {
  description = "Disk size for masters (in Gb)"
  type        = string
  default     = 50
}

# VM Ressources for Workers
variable "worker_cores" {
  description = "Number of CPU for workers"
  type        = number
  default     = 4
}

variable "worker_memory" {
  description = "Memory for workers (in Mb)"
  type        = number
  default     = 8192
}

variable "worker_disk_size" {
  description = "Taille du disque pour les workers (ex: 100G)"
  type        = string
  default     = 100
}

# Network config
variable "vm_bridge" {
  description = "Proxmox's bridge interface"
  type        = string
  default     = "vmbr0"
}

variable "vlan_id" {
  description = "ID VLAN (optionnal)"
  type        = number
  default     = null
}

variable "network_cidr" {
  description = "CIDR (ex: 192.168.1.0/24)"
  type        = string
}

variable "network_gateway" {
  description = "Gateway (ex: 192.168.1.1)"
  type        = string
}

variable "network_dns_servers" {
  description = "DNS"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "ip_start_index" {
  description = "Start range IP (ex: 10 for .10, .11, etc.)"
  type        = number
  default     = 10
}

# Cloud-Init config
variable "vm_user" {
  description = "Default user for VMs"
  type        = string
  default     = "ubuntu"
}

variable "vm_password" {
  description = "Default password for VMs"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH Keys for VMs access"
  type        = string
}

variable "cloud_init_user_data_file_id" {
  description = "user-data file id for Cloud-Init (optional)"
  type        = string
  default     = null
}
