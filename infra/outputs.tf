locals {
  docker_host_address = var.docker_host != "unix:///var/run/docker.sock" ? replace(replace(var.docker_host, "ssh://", ""), "michael@", "") : "localhost"
}

output "portainer_url" {
  description = "URL to access Portainer"
  value       = var.enable_portainer ? "http://${local.docker_host_address}:9000" : "Portainer not enabled"
}

output "plex_url" {
  description = "URL to access Plex"
  value       = var.enable_plex ? "http://${local.docker_host_address}:32400/web" : "Plex not enabled"
}

output "jellyfin_url" {
  description = "URL to access Jellyfin"
  value       = var.enable_jellyfin ? "http://${local.docker_host_address}:8096" : "Jellyfin not enabled"
}

output "immich_url" {
  description = "URL to access Immich"
  value       = var.enable_immich ? "http://${local.docker_host_address}:2283" : "Immich not enabled"
}

output "navidrome_url" {
  description = "URL to access Navidrome"
  value       = var.enable_navidrome ? "http://${local.docker_host_address}:4533" : "Navidrome not enabled"
}

output "audiobookshelf_url" {
  description = "URL to access Audiobookshelf"
  value       = var.enable_audiobookshelf ? "http://${local.docker_host_address}:13378" : "Audiobookshelf not enabled"
}

output "nextcloud_url" {
  description = "URL to access Nextcloud"
  value       = var.enable_nextcloud ? "http://${local.docker_host_address}:8080" : "Nextcloud not enabled"
}

output "deployed_stacks" {
  description = "List of deployed stacks"
  value = concat(
    var.enable_portainer ? ["portainer"] : [],
    var.enable_plex ? ["plex"] : [],
    var.enable_jellyfin ? ["jellyfin"] : [],
    var.enable_immich ? ["immich"] : [],
    var.enable_navidrome ? ["navidrome"] : [],
    var.enable_audiobookshelf ? ["audiobookshelf"] : [],
    var.enable_nextcloud ? ["nextcloud"] : []
  )
}
