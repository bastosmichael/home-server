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
      "sudo mkdir -p /opt/portainer /opt/plex /opt/jellyfin /opt/immich /opt/navidrome /opt/audiobookshelf /opt/nextcloud",
      "sudo mkdir -p /opt/plex/media /opt/jellyfin/cache /opt/jellyfin/media /opt/immich/library /opt/navidrome/music /opt/audiobookshelf/audiobooks /opt/audiobookshelf/podcasts /opt/nextcloud/html",
      "sudo chown -R 1000:1000 /opt/plex /opt/portainer /opt/jellyfin /opt/immich /opt/navidrome /opt/audiobookshelf /opt/nextcloud || true",
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
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/plex/docker-compose.yml" "$USER@$HOST:/tmp/plex.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/jellyfin/docker-compose.yml" "$USER@$HOST:/tmp/jellyfin.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/immich/docker-compose.yml" "$USER@$HOST:/tmp/immich.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/navidrome/docker-compose.yml" "$USER@$HOST:/tmp/navidrome.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/audiobookshelf/docker-compose.yml" "$USER@$HOST:/tmp/audiobookshelf.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/nextcloud/docker-compose.yml" "$USER@$HOST:/tmp/nextcloud.docker-compose.yml"

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

        # Restart DNS resolver to fix "server misbehaving" errors
        sudo systemctl restart systemd-resolved || true

        # Ensure directories exist (in case bootstrap didn't run or new ones matched)
        sudo mkdir -p /opt/portainer /opt/plex /opt/jellyfin /opt/immich /opt/navidrome /opt/audiobookshelf /opt/nextcloud
        sudo mkdir -p /opt/plex/media /opt/jellyfin/cache /opt/jellyfin/media /opt/immich/library /opt/navidrome/music /opt/audiobookshelf/audiobooks /opt/audiobookshelf/podcasts /opt/nextcloud/html
        sudo chown -R 1000:1000 /opt/plex /opt/portainer /opt/jellyfin /opt/immich /opt/navidrome /opt/audiobookshelf /opt/nextcloud || true

        # Configure Firewall (UFW)
        echo "Configuring Firewall..."
        sudo ufw allow 22/tcp  # SSH
        sudo ufw allow 80/tcp  # HTTP (reverse proxies / direct web access)
        sudo ufw allow 443/tcp # HTTPS (reverse proxies / direct web access)
        sudo ufw allow 8000/tcp # Portainer
        sudo ufw allow 9000/tcp # Portainer
        sudo ufw allow 3000/tcp # Open WebUI / dashboards
        sudo ufw allow 32400/tcp # Plex
        sudo ufw allow 8096/tcp  # Jellyfin
        sudo ufw allow 8920/tcp  # Jellyfin HTTPS
        sudo ufw allow 2283/tcp  # Immich
        sudo ufw allow 4533/tcp  # Navidrome
        sudo ufw allow 13378/tcp # Audiobookshelf
        sudo ufw allow 8080/tcp  # Nextcloud
        sudo ufw --force enable || true

        # Move files to correct locations
        sudo mv /tmp/portainer.docker-compose.yml /opt/portainer/docker-compose.yml
        sudo mv /tmp/plex.docker-compose.yml /opt/plex/docker-compose.yml
        sudo mv /tmp/jellyfin.docker-compose.yml /opt/jellyfin/docker-compose.yml
        sudo mv /tmp/immich.docker-compose.yml /opt/immich/docker-compose.yml
        sudo mv /tmp/navidrome.docker-compose.yml /opt/navidrome/docker-compose.yml
        sudo mv /tmp/audiobookshelf.docker-compose.yml /opt/audiobookshelf/docker-compose.yml
        sudo mv /tmp/nextcloud.docker-compose.yml /opt/nextcloud/docker-compose.yml

        # Configure Plex Media Storage
        if [ -d "/mnt/coldstore" ]; then
            echo "Coldstore detected. Pointing Plex media to /mnt/coldstore..."
            sudo sed -i 's|/opt/plex/media:/media|/mnt/coldstore:/media|' /opt/plex/docker-compose.yml
        else
            echo "No coldstore detected. Keeping default /opt/plex/media."
        fi

        if [ -d "/mnt/coldstore" ]; then
            echo "Coldstore detected. Pointing Jellyfin media to /mnt/coldstore/jellyfin..."
            sudo sed -i 's|/opt/jellyfin/media:/media|/mnt/coldstore/jellyfin:/media|' /opt/jellyfin/docker-compose.yml
        else
            echo "No coldstore detected. Keeping default /opt/jellyfin/media."
        fi

        if [ -d "/mnt/coldstore" ]; then
            echo "Coldstore detected. Pointing Immich library to /mnt/coldstore/immich-library..."
            sudo sed -i 's|/opt/immich/library:/usr/src/app/upload|/mnt/coldstore/immich-library:/usr/src/app/upload|' /opt/immich/docker-compose.yml
        else
            echo "No coldstore detected. Keeping default /opt/immich/library."
        fi

        if [ -d "/mnt/coldstore" ]; then
            echo "Coldstore detected. Pointing Navidrome music to /mnt/coldstore/music..."
            sudo sed -i 's|/opt/navidrome/music:/music|/mnt/coldstore/music:/music|' /opt/navidrome/docker-compose.yml
        else
            echo "No coldstore detected. Keeping default /opt/navidrome/music."
        fi

        if [ -d "/mnt/coldstore" ]; then
            echo "Coldstore detected. Pointing Audiobookshelf media to /mnt/coldstore..."
            sudo sed -i 's|/opt/audiobookshelf/audiobooks:/audiobooks|/mnt/coldstore/audiobooks:/audiobooks|' /opt/audiobookshelf/docker-compose.yml
            sudo sed -i 's|/opt/audiobookshelf/podcasts:/podcasts|/mnt/coldstore/podcasts:/podcasts|' /opt/audiobookshelf/docker-compose.yml
        else
            echo "No coldstore detected. Keeping default /opt/audiobookshelf media paths."
        fi

        if [ -d "/mnt/coldstore" ]; then
            echo "Coldstore detected. Pointing Nextcloud data to /mnt/coldstore/nextcloud..."
            sudo sed -i 's|/opt/nextcloud/html:/var/www/html|/mnt/coldstore/nextcloud:/var/www/html|' /opt/nextcloud/docker-compose.yml
        else
            echo "No coldstore detected. Keeping default /opt/nextcloud/html."
        fi

        # Deploy Stacks
        ${var.enable_portainer ? "cd /opt/portainer && (sudo docker rm -f portainer || true) && retry sudo docker compose up -d" : "echo 'Skipping Portainer'"}
        ${var.enable_plex ? "cd /opt/plex && (sudo docker rm -f plex || true) && retry sudo docker compose up -d" : "echo 'Skipping Plex'"}
        ${var.enable_jellyfin ? "cd /opt/jellyfin && (sudo docker rm -f jellyfin || true) && retry sudo docker compose up -d" : "echo 'Skipping Jellyfin'"}
        ${var.enable_immich ? "cd /opt/immich && retry sudo docker compose up -d" : "echo 'Skipping Immich'"}
        ${var.enable_navidrome ? "cd /opt/navidrome && (sudo docker rm -f navidrome || true) && retry sudo docker compose up -d" : "echo 'Skipping Navidrome'"}
        ${var.enable_audiobookshelf ? "cd /opt/audiobookshelf && (sudo docker rm -f audiobookshelf || true) && retry sudo docker compose up -d" : "echo 'Skipping Audiobookshelf'"}
        ${var.enable_nextcloud ? "cd /opt/nextcloud && (sudo docker rm -f nextcloud nextcloud-db nextcloud-redis || true) && retry sudo docker compose up -d" : "echo 'Skipping Nextcloud'"}
      REMOTE_SCRIPT
    EOT
  }
}
