locals {
  docker_host_address = var.docker_host != "unix:///var/run/docker.sock" ? replace(replace(var.docker_host, "ssh://", ""), "michael@", "") : "localhost"
}

output "portainer_url" {
  description = "URL to access Portainer"
  value       = var.enable_portainer ? "http://${local.docker_host_address}:9000" : "Portainer not enabled"
}

output "ollama_url" {
  description = "URL to access Ollama API"
  value       = var.enable_ollama ? "http://${local.docker_host_address}:11434" : "Ollama not enabled"
}

output "rust_server_port" {
  description = "Rust server connection port"
  value       = var.enable_rust ? "28015" : "Rust server not enabled"
}

output "ark_server_port" {
  description = "ARK server connection port"
  value       = var.enable_ark ? "7777" : "ARK server not enabled"
}

output "cs2_server_port" {
  description = "CS2 server connection port"
  value       = var.enable_cs2 ? "27015" : "CS2 server not enabled"
}

output "minecraft_server_port" {
  description = "Minecraft server connection port"
  value       = var.enable_minecraft ? "25565" : "Minecraft server not enabled"
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

output "tf2_server_port" {
  description = "Team Fortress 2 server connection port"
  value       = var.enable_tf2 ? "27015" : "TF2 server not enabled"
}

output "garrysmod_server_port" {
  description = "Garry's Mod server connection port"
  value       = var.enable_garrysmod ? "27015" : "Garry's Mod server not enabled"
}

output "insurgency_sandstorm_server_ports" {
  description = "Insurgency: Sandstorm game and query ports"
  value       = var.enable_insurgency_sandstorm ? "27102 (game), 27131 (query)" : "Insurgency: Sandstorm server not enabled"
}

output "squad_server_ports" {
  description = "Squad game and query ports"
  value       = var.enable_squad ? "7787 (game), 27165 (query)" : "Squad server not enabled"
}

output "squad44_server_ports" {
  description = "Squad 44 game and query ports"
  value       = var.enable_squad44 ? "10027 (game), 10037 (query)" : "Squad 44 server not enabled"
}

output "satisfactory_server_ports" {
  description = "Satisfactory server ports"
  value       = var.enable_satisfactory ? "7777, 15000, 15777 (udp)" : "Satisfactory server not enabled"
}

output "factorio_server_ports" {
  description = "Factorio server ports"
  value       = var.enable_factorio ? "34197 (udp), 27015 (tcp)" : "Factorio server not enabled"
}

output "eco_server_ports" {
  description = "Eco server ports"
  value       = var.enable_eco ? "3000 (tcp), 3001 (udp)" : "Eco server not enabled"
}

output "space_engineers_server_ports" {
  description = "Space Engineers server ports"
  value       = var.enable_space_engineers ? "27016 (udp), 8766 (udp)" : "Space Engineers server not enabled"
}

output "starbound_server_port" {
  description = "Starbound server port"
  value       = var.enable_starbound ? "21025/tcp" : "Starbound server not enabled"
}

output "aoe2de_server_ports" {
  description = "Age of Empires II: Definitive Edition server ports"
  value       = var.enable_aoe2de ? "27015 (udp), 27016 (udp)" : "AoE2: DE server not enabled"
}

output "palworld_server_ports" {
  description = "Palworld server ports"
  value       = var.enable_palworld ? "8211 (udp), 27015 (udp)" : "Palworld server not enabled"
}

output "arma3_server_ports" {
  description = "Arma 3 server ports"
  value       = var.enable_arma3 ? "2302-2305 (udp)" : "Arma 3 server not enabled"
}

output "deployed_stacks" {
  description = "List of deployed stacks"
  value = concat(
    var.enable_portainer ? ["portainer"] : [],
    var.enable_ollama ? ["ollama"] : [],
    var.enable_rust ? ["rust"] : [],
    var.enable_ark ? ["ark"] : [],
    var.enable_cs2 ? ["cs2"] : [],
    var.enable_minecraft ? ["minecraft"] : [],
    var.enable_plex ? ["plex"] : [],
    var.enable_jellyfin ? ["jellyfin"] : [],
    var.enable_immich ? ["immich"] : [],
    var.enable_navidrome ? ["navidrome"] : [],
    var.enable_audiobookshelf ? ["audiobookshelf"] : [],
    var.enable_nextcloud ? ["nextcloud"] : [],
    var.enable_tf2 ? ["tf2"] : [],
    var.enable_garrysmod ? ["garrysmod"] : [],
    var.enable_insurgency_sandstorm ? ["insurgency_sandstorm"] : [],
    var.enable_squad ? ["squad"] : [],
    var.enable_squad44 ? ["squad44"] : [],
    var.enable_satisfactory ? ["satisfactory"] : [],
    var.enable_factorio ? ["factorio"] : [],
    var.enable_eco ? ["eco"] : [],
    var.enable_space_engineers ? ["space_engineers"] : [],
    var.enable_starbound ? ["starbound"] : [],
    var.enable_aoe2de ? ["aoe2de"] : [],
    var.enable_palworld ? ["palworld"] : [],
    var.enable_arma3 ? ["arma3"] : []
  )
}
