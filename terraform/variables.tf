# variables.tf - Variables pour provider BPG

# Configuration Proxmox
variable "proxmox_api_url" {
  description = "URL de l'API Proxmox (ex: https://proxmox.example.com:8006)"
  type        = string
}

variable "proxmox_api_token_id" {
  description = "ID du token API Proxmox (ex: terraform-prov@pve!mytoken)"
  type        = string
}

variable "proxmox_api_token_secret" {
  description = "Secret du token API Proxmox"
  type        = string
  sensitive   = true
}

# Alternative: authentification par mot de passe
variable "proxmox_username" {
  description = "Nom d'utilisateur Proxmox (ex: root@pam)"
  type        = string
  default     = null
}

variable "proxmox_password" {
  description = "Mot de passe Proxmox"
  type        = string
  default     = null
  sensitive   = true
}

variable "proxmox_nodes" {
  description = "Liste des nœuds Proxmox disponibles"
  type        = list(string)
  default     = ["pve-1", "pve-2"]
}

# Configuration des templates/clones
variable "template_name" {
  description = "Nom du template à cloner (ex: ubuntu-cloud-template)"
  type        = string
}

variable "template_vm_id_pve1" {
  description = "ID du template VM sur pve-1"
  type        = number
  default     = 9000
}

variable "template_vm_id_pve2" {
  description = "ID du template VM sur pve-2"
  type        = number
  default     = 9001
}

# Configuration des VMs
variable "vm_start_id" {
  description = "ID de départ pour les VMs"
  type        = number
  default     = 1000
}

variable "master_count" {
  description = "Nombre de masters Kubernetes"
  type        = number
  default     = 3
}

variable "worker_count" {
  description = "Nombre de workers Kubernetes"
  type        = number
  default     = 3
}

# Ressources Masters
variable "master_cores" {
  description = "Nombre de cœurs CPU pour les masters"
  type        = number
  default     = 2
}

variable "master_memory" {
  description = "RAM en MB pour les masters"
  type        = number
  default     = 4096
}

variable "master_disk_size" {
  description = "Taille du disque pour les masters (ex: 50G)"
  type        = string
  default     = 50
}

# Ressources Workers
variable "worker_cores" {
  description = "Nombre de cœurs CPU pour les workers"
  type        = number
  default     = 4
}

variable "worker_memory" {
  description = "RAM en MB pour les workers"
  type        = number
  default     = 8192
}

variable "worker_disk_size" {
  description = "Taille du disque pour les workers (ex: 100G)"
  type        = string
  default     = 100
}

# Configuration réseau
variable "vm_bridge" {
  description = "Bridge réseau Proxmox"
  type        = string
  default     = "vmbr0"
}

variable "vlan_id" {
  description = "ID VLAN (optionnel)"
  type        = number
  default     = null
}

variable "network_cidr" {
  description = "CIDR du réseau (ex: 192.168.1.0/24)"
  type        = string
}

variable "network_gateway" {
  description = "Passerelle réseau (ex: 192.168.1.1)"
  type        = string
}

variable "network_dns_servers" {
  description = "Serveurs DNS"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "ip_start_index" {
  description = "Index de départ pour les IPs (ex: 10 pour .10, .11, etc.)"
  type        = number
  default     = 10
}

# Configuration Cloud-Init
variable "vm_user" {
  description = "Utilisateur par défaut des VMs"
  type        = string
  default     = "ubuntu"
}

variable "vm_password" {
  description = "Mot de passe par défaut des VMs"
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "Clé SSH publique pour l'accès aux VMs"
  type        = string
}

variable "cloud_init_user_data_file_id" {
  description = "ID du fichier user-data Cloud-Init (optionnel)"
  type        = string
  default     = null
}
