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
