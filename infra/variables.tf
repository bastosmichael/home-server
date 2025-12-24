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

variable "enable_minecraft" {
  description = "Enable Minecraft server stack deployment"
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

variable "enable_tf2" {
  description = "Enable Team Fortress 2 server deployment"
  type        = bool
  default     = false
}

variable "enable_garrysmod" {
  description = "Enable Garry's Mod server deployment"
  type        = bool
  default     = false
}

variable "enable_insurgency_sandstorm" {
  description = "Enable Insurgency: Sandstorm server deployment"
  type        = bool
  default     = false
}

variable "enable_squad" {
  description = "Enable Squad server deployment"
  type        = bool
  default     = false
}

variable "enable_squad44" {
  description = "Enable Squad 44 server deployment"
  type        = bool
  default     = false
}

variable "enable_satisfactory" {
  description = "Enable Satisfactory server deployment"
  type        = bool
  default     = false
}

variable "enable_factorio" {
  description = "Enable Factorio server deployment"
  type        = bool
  default     = false
}

variable "enable_eco" {
  description = "Enable Eco server deployment"
  type        = bool
  default     = false
}

variable "enable_space_engineers" {
  description = "Enable Space Engineers server deployment"
  type        = bool
  default     = false
}

variable "enable_starbound" {
  description = "Enable Starbound server deployment"
  type        = bool
  default     = false
}

variable "enable_aoe2de" {
  description = "Enable Age of Empires II: Definitive Edition server deployment"
  type        = bool
  default     = false
}

variable "enable_palworld" {
  description = "Enable Palworld server deployment"
  type        = bool
  default     = false
}

variable "enable_arma3" {
  description = "Enable Arma 3 server deployment"
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
