terraform {
  required_version = ">= 1.0"

  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.2"
    }
  }
}

provider "null" {}

resource "null_resource" "bootstrap_docker" {
  connection {
    type = "ssh"
    host = replace(var.docker_host, "ssh://michael@", "") # Extract IP from docker_host string
    user = "michael"
    # Agent is used automatically
  }

  provisioner "remote-exec" {
    inline = [
      # Basic deps
      # "sudo apt-get update -y",
      # "sudo apt-get install -y ca-certificates curl gnupg lsb-release",

      # Install Docker Engine + compose plugin (official repo)
      # "sudo install -m 0755 -d /etc/apt/keyrings",
      # "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",
      # "sudo chmod a+r /etc/apt/keyrings/docker.asc",
      # "sudo bash -lc 'source /etc/os-release; cat > /etc/apt/sources.list.d/docker.sources <<EOF\nTypes: deb\nURIs: https://download.docker.com/linux/ubuntu\nSuites: $${UBUNTU_CODENAME:-$VERSION_CODENAME}\nComponents: stable\nSigned-By: /etc/apt/keyrings/docker.asc\nEOF'",
      # "sudo apt-get update -y",
      # "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",

      # Enable docker at boot
      # "sudo systemctl enable --now docker",

      # Ensure current user is in docker group (requires relogin, but good for future)
      # "sudo usermod -aG docker $USER || true",

      # Create stack dirs
      "sudo mkdir -p /opt/portainer /opt/ollama /opt/rust-server /opt/ark /opt/cs2 /opt/minecraft /opt/plex /opt/tf2 /opt/garrysmod /opt/insurgency-sandstorm /opt/squad /opt/squad44 /opt/satisfactory /opt/factorio /opt/eco /opt/space-engineers /opt/starbound /opt/aoe2de /opt/palworld /opt/arma3",
      "sudo mkdir -p /opt/cs2/data",
      "sudo mkdir -p /opt/plex/media",
      "sudo chown -R 1000:1000 /opt/cs2/data || true",
    ]
  }
}

# Deploy Stacks
resource "null_resource" "deploy_stacks" {
  depends_on = [null_resource.bootstrap_docker]

  provisioner "local-exec" {
    command = <<EOT
      # Define HOST and USER
      HOST="${replace(var.docker_host, "ssh://michael@", "")}"
      USER="michael"

      # Copy Compose Files via SCP (renaming on destination to avoid collisions)
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/portainer/docker-compose.yml" "$USER@$HOST:/tmp/portainer.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/ollama/docker-compose.yml" "$USER@$HOST:/tmp/ollama.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/openwebui/docker-compose.yml" "$USER@$HOST:/tmp/openwebui.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/adguard/docker-compose.yml" "$USER@$HOST:/tmp/adguard.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/traefik/docker-compose.yml" "$USER@$HOST:/tmp/traefik.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/rust/docker-compose.yml" "$USER@$HOST:/tmp/rust.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/ark/docker-compose.yml" "$USER@$HOST:/tmp/ark.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/cs2/docker-compose.yml" "$USER@$HOST:/tmp/cs2.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/minecraft/docker-compose.yml" "$USER@$HOST:/tmp/minecraft.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/plex/docker-compose.yml" "$USER@$HOST:/tmp/plex.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/tf2/docker-compose.yml" "$USER@$HOST:/tmp/tf2.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/garrysmod/docker-compose.yml" "$USER@$HOST:/tmp/garrysmod.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/insurgency_sandstorm/docker-compose.yml" "$USER@$HOST:/tmp/insurgency_sandstorm.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/squad/docker-compose.yml" "$USER@$HOST:/tmp/squad.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/squad44/docker-compose.yml" "$USER@$HOST:/tmp/squad44.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/satisfactory/docker-compose.yml" "$USER@$HOST:/tmp/satisfactory.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/factorio/docker-compose.yml" "$USER@$HOST:/tmp/factorio.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/eco/docker-compose.yml" "$USER@$HOST:/tmp/eco.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/space_engineers/docker-compose.yml" "$USER@$HOST:/tmp/space_engineers.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/starbound/docker-compose.yml" "$USER@$HOST:/tmp/starbound.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/aoe2de/docker-compose.yml" "$USER@$HOST:/tmp/aoe2de.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/palworld/docker-compose.yml" "$USER@$HOST:/tmp/palworld.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/arma3/docker-compose.yml" "$USER@$HOST:/tmp/arma3.docker-compose.yml"

      # Execute Remote Setup via SSH
      ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$USER@$HOST" 'bash -s' <<'REMOTE_SCRIPT'
        set -e
        
        # Helper for retrying commands (fixes transient DNS/network issues)
        function retry {
          local retries=5
          local count=0
          until "$@"; do
            exit=$?
            wait=$((2 ** count))
            count=$((count + 1))
            if [ $count -lt $retries ]; then
              echo "Retry $count/$retries exited $exit, retrying in $wait seconds..."
              sleep $wait
            else
              echo "Retry $count/$retries exited $exit, no more retries left."
              return $exit
            fi
          done
          return 0
        }

        # Helper to validate container health before pausing
        function check_and_pause {
          local container_name=$1
          echo "Waiting 60s for $container_name to initialize..."
          sleep 60
          
          # Check if container is currently running (not exited/restarting)
          if sudo docker ps --filter "name=$container_name" --filter "status=running" --format "{{.Names}}" | grep -q "^$container_name$"; then
            echo "SUCCESS: $container_name is healthy and running. Pausing now to save RAM..."
            sudo docker compose pause
          else
            echo "ERROR: $container_name is NOT running after start-up period. It may have crashed."
            echo "Recent logs for $container_name:"
            sudo docker logs --tail 20 "$container_name" || true
            # We do NOT pause if it's broken, so valid logs are preserved/visible in Portainer
          fi
        }

        # Restart DNS resolver to fix "server misbehaving" errors
        # Disable systemd-resolved stub listener to allow AdGuard on port 53
        if grep -q "DNSStubListener=yes" /etc/systemd/resolved.conf || grep -q "#DNSStubListener=yes" /etc/systemd/resolved.conf; then
             echo "Disabling DNSStubListener for AdGuard..."
             sudo sed -i 's/#DNSStubListener=yes/DNSStubListener=no/' /etc/systemd/resolved.conf
             sudo sed -i 's/DNSStubListener=yes/DNSStubListener=no/' /etc/systemd/resolved.conf
             # Ensure we have temporary DNS to pull images
             sudo rm -f /etc/resolv.conf
             echo "nameserver 1.1.1.1" | sudo tee /etc/resolv.conf > /dev/null
             sudo systemctl restart systemd-resolved || true
        fi

        # Create Proxy Network
        sudo docker network create proxy || true
        
        # Ensure directories exist (in case bootstrap didn't run or new ones matched)
        sudo mkdir -p /opt/portainer /opt/ollama /opt/openwebui /opt/adguard/work /opt/adguard/conf /opt/traefik /opt/rust-server /opt/ark /opt/cs2 /opt/minecraft /opt/plex \
          /opt/tf2 /opt/garrysmod /opt/insurgency-sandstorm /opt/squad /opt/squad44 /opt/satisfactory /opt/factorio \
          /opt/eco /opt/space-engineers /opt/starbound /opt/aoe2de /opt/palworld /opt/arma3
        sudo mkdir -p /opt/cs2/data /opt/plex/media
        sudo chown -R 1000:1000 /opt/cs2/data /opt/ark /opt/plex /opt/portainer /opt/ollama /opt/openwebui /opt/adguard /opt/traefik /opt/rust-server /opt/minecraft \
          /opt/tf2 /opt/garrysmod /opt/insurgency-sandstorm /opt/squad /opt/squad44 /opt/satisfactory /opt/factorio /opt/eco \
          /opt/space-engineers /opt/starbound /opt/aoe2de /opt/palworld /opt/arma3 || true

        # Configure Firewall (UFW)
        echo "Configuring Firewall..."
        sudo ufw allow 22/tcp  # SSH
        sudo ufw allow 80/tcp  # Traefik HTTP
        sudo ufw allow 53/tcp  # AdGuard DNS
        sudo ufw allow 53/udp  # AdGuard DNS
        sudo ufw allow 3001/tcp # AdGuard Setup
        sudo ufw allow 8081/tcp # AdGuard Admin
        sudo ufw allow 8000/tcp # Portainer
        sudo ufw allow 9000/tcp # Portainer
        sudo ufw allow 11434/tcp # Ollama
        sudo ufw allow 32400/tcp # Plex
        sudo ufw allow 28015:28016/udp # Rust
        sudo ufw allow 28015:28016/tcp # Rust RCON
        sudo ufw allow 7777:7778/udp # Ark
        sudo ufw allow 27015/udp     # CS2 / Ark Query
        sudo ufw allow 27015/tcp     # CS2 RCON
        sudo ufw allow 25565/tcp     # Minecraft
        sudo ufw allow 27017/udp     # TF2
        sudo ufw allow 27017/tcp     # TF2 RCON
        sudo ufw allow 27008/udp     # Garry's Mod
        sudo ufw allow 27018/udp     # Garry's Mod
        sudo ufw allow 27102/udp     # Insurgency: Sandstorm
        sudo ufw allow 27131/udp     # Insurgency: Sandstorm
        sudo ufw allow 7787/udp      # Squad
        sudo ufw allow 27165/udp     # Squad
        sudo ufw allow 27165/tcp     # Squad RCON
        sudo ufw allow 10027/udp     # Squad 44
        sudo ufw allow 10037/udp     # Squad 44
        sudo ufw allow 15000/udp     # Satisfactory
        sudo ufw allow 15777/udp     # Satisfactory
        sudo ufw allow 7779/udp      # Satisfactory (Mapped)
        sudo ufw allow 34197/udp     # Factorio
        sudo ufw allow 27022/tcp     # Factorio RCON
        sudo ufw allow 3010/tcp      # Eco
        sudo ufw allow 3011/udp      # Eco
        sudo ufw allow 27019/udp     # Space Engineers
        sudo ufw allow 8766/udp      # Space Engineers
        sudo ufw allow 21025/tcp     # Starbound
        sudo ufw allow 27020:27021/udp # AoE2 DE
        sudo ufw allow 8211/udp      # Palworld
        sudo ufw allow 27023/udp     # Palworld
        sudo ufw allow 2302:2306/udp # Arma 3
        sudo ufw --force enable || true

        # Move files to correct locations
        sudo mv /tmp/portainer.docker-compose.yml /opt/portainer/docker-compose.yml
        sudo mv /tmp/openwebui.docker-compose.yml /opt/openwebui/docker-compose.yml
        sudo mv /tmp/adguard.docker-compose.yml /opt/adguard/docker-compose.yml
        sudo mv /tmp/traefik.docker-compose.yml /opt/traefik/docker-compose.yml
        
        # Configure Ollama with GPU support if NVIDIA GPU is present
        if command -v nvidia-smi &> /dev/null; then
          echo "NVIDIA GPU detected. Enabling GPU support for Ollama..."
          cat <<EOF | sudo tee /opt/ollama/docker-compose.yml > /dev/null
version: '3.8'

services:
  ollama:
    image: ollama/ollama:latest
    container_name: ollama
    restart: unless-stopped
    ports:
      - "11434:11434"
    volumes:
      - ollama_data:/root/.ollama
    networks:
      - proxy
    labels:
      - "traefik.enable=true"
      - "traefik.http.services.ollama.loadbalancer.server.port=11434"
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]

volumes:
  ollama_data:

networks:
  proxy:
    external: true
EOF
          # Clean up the temp CPU File
          sudo rm -f /tmp/ollama.docker-compose.yml
        else
          echo "No NVIDIA GPU detected. Using CPU mode for Ollama."
          sudo mv /tmp/ollama.docker-compose.yml /opt/ollama/docker-compose.yml
        fi

        sudo mv /tmp/rust.docker-compose.yml /opt/rust-server/docker-compose.yml
        sudo mv /tmp/ark.docker-compose.yml /opt/ark/docker-compose.yml
        sudo mv /tmp/minecraft.docker-compose.yml /opt/minecraft/docker-compose.yml
        sudo mv /tmp/plex.docker-compose.yml /opt/plex/docker-compose.yml
        sudo mv /tmp/tf2.docker-compose.yml /opt/tf2/docker-compose.yml
        sudo mv /tmp/garrysmod.docker-compose.yml /opt/garrysmod/docker-compose.yml
        sudo mv /tmp/insurgency_sandstorm.docker-compose.yml /opt/insurgency-sandstorm/docker-compose.yml
        sudo mv /tmp/squad.docker-compose.yml /opt/squad/docker-compose.yml
        sudo mv /tmp/squad44.docker-compose.yml /opt/squad44/docker-compose.yml
        sudo mv /tmp/satisfactory.docker-compose.yml /opt/satisfactory/docker-compose.yml
        sudo mv /tmp/factorio.docker-compose.yml /opt/factorio/docker-compose.yml
        sudo mv /tmp/eco.docker-compose.yml /opt/eco/docker-compose.yml
        sudo mv /tmp/space_engineers.docker-compose.yml /opt/space-engineers/docker-compose.yml
        sudo mv /tmp/starbound.docker-compose.yml /opt/starbound/docker-compose.yml
        sudo mv /tmp/aoe2de.docker-compose.yml /opt/aoe2de/docker-compose.yml
        sudo mv /tmp/palworld.docker-compose.yml /opt/palworld/docker-compose.yml
        sudo mv /tmp/arma3.docker-compose.yml /opt/arma3/docker-compose.yml

        # Handle CS2 Template Replacement
        sudo mkdir -p /opt/cs2
        sudo sed -e "s/__CS2_GSLT__/${var.cs2_gslt}/g" /tmp/cs2.docker-compose.yml | sudo tee /opt/cs2/docker-compose.yml >/dev/null
        sudo rm -f /tmp/cs2.docker-compose.yml

        # Deploy Stacks
        ${var.enable_adguard ? "cd /opt/adguard && (sudo docker rm -f adguard || true) && retry sudo docker compose up -d" : "echo 'Skipping AdGuard'"}
        ${var.enable_traefik ? "cd /opt/traefik && (sudo docker rm -f traefik || true) && retry sudo docker compose up -d" : "echo 'Skipping Traefik'"}
        ${var.enable_portainer ? "cd /opt/portainer && (sudo docker rm -f portainer || true) && retry sudo docker compose up -d" : "echo 'Skipping Portainer'"}
        ${var.enable_ollama ? "cd /opt/ollama && (sudo docker rm -f ollama || true) && retry sudo docker compose up -d && sleep 10 && retry sudo docker exec ollama ollama pull tinyllama && retry sudo docker exec ollama ollama pull starcoder:1b" : "echo 'Skipping Ollama'"}
        ${var.enable_openwebui ? "cd /opt/openwebui && (sudo docker rm -f openwebui || true) && retry sudo docker compose up -d" : "echo 'Skipping OpenWebUI'"}
        ${var.enable_rust ? "cd /opt/rust-server && (sudo docker rm -f rust-server || true) && retry sudo docker compose up -d && check_and_pause rust-server" : "echo 'Skipping Rust'"}
        ${var.enable_ark ? "cd /opt/ark && (sudo docker rm -f ark-server ark_server || true) && retry sudo docker compose up -d && check_and_pause ark-server" : "echo 'Skipping ARK'"}
        ${var.enable_cs2 ? "cd /opt/cs2 && (sudo docker rm -f cs2-server cs2_server || true) && retry sudo docker compose up -d && check_and_pause cs2-server" : "echo 'Skipping CS2'"}
        ${var.enable_minecraft ? "cd /opt/minecraft && (sudo docker rm -f minecraft-server || true) && retry sudo docker compose up -d && check_and_pause minecraft-server" : "echo 'Skipping Minecraft'"}
        ${var.enable_plex ? "cd /opt/plex && (sudo docker rm -f plex || true) && retry sudo docker compose up -d" : "echo 'Skipping Plex'"}
        ${var.enable_tf2 ? "cd /opt/tf2 && (sudo docker rm -f tf2-server || true) && retry sudo docker compose up -d && check_and_pause tf2-server" : "echo 'Skipping TF2'"}
        ${var.enable_garrysmod ? "cd /opt/garrysmod && (sudo docker rm -f garrysmod-server || true) && retry sudo docker compose up -d && check_and_pause garrysmod-server" : "echo \"Skipping Garry's Mod\""}
        ${var.enable_insurgency_sandstorm ? "cd /opt/insurgency-sandstorm && (sudo docker rm -f insurgency-sandstorm-server || true) && retry sudo docker compose up -d && check_and_pause insurgency-sandstorm-server" : "echo 'Skipping Insurgency: Sandstorm'"}
        ${var.enable_squad ? "cd /opt/squad && (sudo docker rm -f squad-server || true) && retry sudo docker compose up -d && check_and_pause squad-server" : "echo 'Skipping Squad'"}
        ${var.enable_squad44 ? "cd /opt/squad44 && (sudo docker rm -f squad44-server || true) && retry sudo docker compose up -d && check_and_pause squad44-server" : "echo 'Skipping Squad 44'"}
        ${var.enable_satisfactory ? "cd /opt/satisfactory && (sudo docker rm -f satisfactory-server || true) && retry sudo docker compose up -d && check_and_pause satisfactory-server" : "echo 'Skipping Satisfactory'"}
        ${var.enable_factorio ? "cd /opt/factorio && (sudo docker rm -f factorio-server || true) && retry sudo docker compose up -d && check_and_pause factorio-server" : "echo 'Skipping Factorio'"}
        ${var.enable_eco ? "cd /opt/eco && (sudo docker rm -f eco-server || true) && retry sudo docker compose up -d && check_and_pause eco-server" : "echo 'Skipping Eco'"}
        ${var.enable_space_engineers ? "cd /opt/space-engineers && (sudo docker rm -f space-engineers-server || true) && retry sudo docker compose up -d && check_and_pause space-engineers-server" : "echo 'Skipping Space Engineers'"}
        ${var.enable_starbound ? "cd /opt/starbound && (sudo docker rm -f starbound-server || true) && retry sudo docker compose up -d && check_and_pause starbound-server" : "echo 'Skipping Starbound'"}
        ${var.enable_aoe2de ? "cd /opt/aoe2de && (sudo docker rm -f aoe2de-server || true) && retry sudo docker compose up -d && check_and_pause aoe2de-server" : "echo 'Skipping Age of Empires II: DE'"}
        ${var.enable_palworld ? "cd /opt/palworld && (sudo docker rm -f palworld-server || true) && retry sudo docker compose up -d && check_and_pause palworld-server" : "echo 'Skipping Palworld'"}
        ${var.enable_arma3 ? "cd /opt/arma3 && (sudo docker rm -f arma3-server || true) && retry sudo docker compose up -d && check_and_pause arma3-server" : "echo 'Skipping Arma 3'"}
REMOTE_SCRIPT
    EOT
  }
}
