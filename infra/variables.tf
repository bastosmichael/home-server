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

variable "enable_plex" {
  description = "Enable Plex stack deployment"
  type        = bool
  default     = false
}

variable "enable_jellyfin" {
  description = "Enable Jellyfin stack deployment"
  type        = bool
  default     = false
}

variable "enable_immich" {
  description = "Enable Immich stack deployment"
  type        = bool
  default     = false
}

variable "enable_navidrome" {
  description = "Enable Navidrome stack deployment"
  type        = bool
  default     = false
}

variable "enable_audiobookshelf" {
  description = "Enable Audiobookshelf stack deployment"
  type        = bool
  default     = false
}

variable "enable_nextcloud" {
  description = "Enable Nextcloud stack deployment"
  type        = bool
  default     = false
}

variable "enable_ai_extras" {
  description = "Enable optional AI extras stack deployment"
  type        = bool
  default     = false
}

variable "enable_cloudflared" {
  description = "Enable Cloudflare Tunnel (cloudflared) deployment"
  type        = bool
  default     = false
}

variable "cloudflared_tunnel_token" {
  description = "Cloudflare Tunnel token used by cloudflared when enabled"
  type        = string
  default     = ""
}
