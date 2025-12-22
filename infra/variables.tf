variable "docker_host" {
  description = "Docker daemon socket to connect to"
  type        = string
  default     = "unix:///var/run/docker.sock"
}

variable "enable_portainer" {
  description = "Enable Portainer stack deployment"
  type        = bool
  default     = true
}

variable "enable_ollama" {
  description = "Enable Ollama stack deployment"
  type        = bool
  default     = false
}

variable "enable_rust" {
  description = "Enable Rust server stack deployment"
  type        = bool
  default     = false
}

variable "enable_ark" {
  description = "Enable ARK server stack deployment"
  type        = bool
  default     = false
}

variable "enable_cs2" {
  description = "Enable CS2 server stack deployment"
  type        = bool
  default     = false
}

# Server Configuration Variables
variable "ark_server_password" {
  description = "ARK server password (leave empty for no password)"
  type        = string
  default     = ""
  sensitive   = true
}

variable "ark_admin_password" {
  description = "ARK server admin password"
  type        = string
  default     = "change-me-admin-pass"
  sensitive   = true
}

variable "cs2_gslt" {
  description = "CS2 Game Server Login Token from Steam"
  type        = string
  default     = ""
  sensitive   = true
}
