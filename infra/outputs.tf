output "portainer_url" {
  description = "URL to access Portainer"
  value       = var.enable_portainer ? "http://localhost:9000" : "Portainer not enabled"
}

output "ollama_url" {
  description = "URL to access Ollama API"
  value       = var.enable_ollama ? "http://localhost:11434" : "Ollama not enabled"
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

output "deployed_stacks" {
  description = "List of deployed stacks"
  value = concat(
    var.enable_portainer ? ["portainer"] : [],
    var.enable_ollama ? ["ollama"] : [],
    var.enable_rust ? ["rust"] : [],
    var.enable_ark ? ["ark"] : [],
    var.enable_cs2 ? ["cs2"] : [],
    var.enable_minecraft ? ["minecraft"] : []
  )
}
