terraform {
  required_version = ">= 1.0"
  
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = var.docker_host
}

# Portainer Stack
resource "docker_container" "portainer" {
  count = var.enable_portainer ? 1 : 0
  
  name  = "portainer"
  image = docker_image.portainer[0].image_id
  
  restart = "unless-stopped"
  
  ports {
    internal = 9000
    external = 9000
  }
  
  ports {
    internal = 8000
    external = 8000
  }
  
  volumes {
    host_path      = "/var/run/docker.sock"
    container_path = "/var/run/docker.sock"
  }
  
  volumes {
    volume_name    = docker_volume.portainer_data[0].name
    container_path = "/data"
  }
}

resource "docker_image" "portainer" {
  count = var.enable_portainer ? 1 : 0
  name  = "portainer/portainer-ce:latest"
}

resource "docker_volume" "portainer_data" {
  count = var.enable_portainer ? 1 : 0
  name  = "portainer_data"
}

# Ollama Stack
resource "docker_container" "ollama" {
  count = var.enable_ollama ? 1 : 0
  
  name  = "ollama"
  image = docker_image.ollama[0].image_id
  
  restart = "unless-stopped"
  
  ports {
    internal = 11434
    external = 11434
  }
  
  volumes {
    volume_name    = docker_volume.ollama_data[0].name
    container_path = "/root/.ollama"
  }
}

resource "docker_image" "ollama" {
  count = var.enable_ollama ? 1 : 0
  name  = "ollama/ollama:latest"
}

resource "docker_volume" "ollama_data" {
  count = var.enable_ollama ? 1 : 0
  name  = "ollama_data"
}

# Rust Server Stack
resource "docker_container" "rust" {
  count = var.enable_rust ? 1 : 0
  
  name  = "rust-server"
  image = docker_image.rust[0].image_id
  
  restart = "unless-stopped"
  
  ports {
    internal = 28015
    external = 28015
  }
  
  ports {
    internal = 28016
    external = 28016
  }
  
  env = [
    "RUST_SERVER_STARTUP_ARGUMENTS=-batchmode -load +server.secure 1",
    "RUST_SERVER_IDENTITY=docker",
    "RUST_SERVER_SEED=12345",
    "RUST_SERVER_WORLDSIZE=3000",
    "RUST_SERVER_NAME=Rust Server",
    "RUST_SERVER_MAXPLAYERS=50"
  ]
  
  volumes {
    volume_name    = docker_volume.rust_data[0].name
    container_path = "/steamcmd/rust"
  }
}

resource "docker_image" "rust" {
  count = var.enable_rust ? 1 : 0
  name  = "didstopia/rust-server:latest"
}

resource "docker_volume" "rust_data" {
  count = var.enable_rust ? 1 : 0
  name  = "rust_data"
}

# ARK Server Stack
resource "docker_container" "ark" {
  count = var.enable_ark ? 1 : 0
  
  name  = "ark-server"
  image = docker_image.ark[0].image_id
  
  restart = "unless-stopped"
  
  ports {
    internal = 7777
    external = 7777
    protocol = "udp"
  }
  
  ports {
    internal = 7778
    external = 7778
    protocol = "udp"
  }
  
  ports {
    internal = 27015
    external = 27015
    protocol = "udp"
  }
  
  env = [
    "GAME_PORT=7777",
    "QUERY_PORT=27015",
    "RCON_PORT=27020",
    "SERVER_PASSWORD=${var.ark_server_password}",
    "ADMIN_PASSWORD=${var.ark_admin_password}"
  ]
  
  volumes {
    volume_name    = docker_volume.ark_data[0].name
    container_path = "/ark"
  }
}

resource "docker_image" "ark" {
  count = var.enable_ark ? 1 : 0
  name  = "acekorneya/ark_ascended_docker:latest"
}

resource "docker_volume" "ark_data" {
  count = var.enable_ark ? 1 : 0
  name  = "ark_data"
}

# CS2 Server Stack
resource "docker_container" "cs2" {
  count = var.enable_cs2 ? 1 : 0
  
  name  = "cs2-server"
  image = docker_image.cs2[0].image_id
  
  restart = "unless-stopped"
  
  ports {
    internal = 27015
    external = 27015
    protocol = "tcp"
  }
  
  ports {
    internal = 27015
    external = 27015
    protocol = "udp"
  }
  
  env = [
    "CS2_SERVERNAME=CS2 Server",
    "CS2_PORT=27015",
    "CS2_MAXPLAYERS=32",
    "CS2_GSLT=${var.cs2_gslt}"
  ]
  
  volumes {
    volume_name    = docker_volume.cs2_data[0].name
    container_path = "/home/steam/cs2-dedicated"
  }
}

resource "docker_image" "cs2" {
  count = var.enable_cs2 ? 1 : 0
  name  = "joedwards32/cs2:latest"
}

resource "docker_volume" "cs2_data" {
  count = var.enable_cs2 ? 1 : 0
  name  = "cs2_data"
}
