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
  triggers = {
    docker_host   = var.docker_host
    daemon_config = "v1" # Force update for daemon.json entry
  }
  provisioner "local-exec" {
    command = <<EOT
      HOST="${replace(var.docker_host, "ssh://michael@", "")}"
      USER="michael"

      ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "$USER@$HOST" 'bash -s' <<'REMOTE_SCRIPT'
        # Configure Docker default address pools (fixes 'all predefined address pools have been fully subnetted')
        echo '{"default-address-pools":[{"base":"10.0.0.0/8","size":24}]}' | sudo tee /etc/docker/daemon.json > /dev/null
        sudo systemctl restart docker

        # Restart DNS resolver (just in case)
        sudo systemctl restart systemd-resolved || true

        # Create stack dirs
        sudo mkdir -p /opt/portainer /opt/plex /opt/jellyfin /opt/immich /opt/navidrome /opt/audiobookshelf /opt/nextcloud /opt/nginxproxymanager /opt/startpage /opt/vaultwarden /opt/hoarder /opt/docmost /opt/octoprint /opt/arrfiles /opt/tautulli /opt/overseerr /opt/radarr /opt/sonarr /opt/lidarr /opt/bazarr /opt/prowlarr /opt/qbittorrent /opt/nzbget /opt/homeassistant /opt/zigbee2mqtt /opt/frigate /opt/grafana /opt/influxdb /opt/prometheus /opt/media
        sudo mkdir -p /opt/plex/media /opt/jellyfin/cache /opt/jellyfin/media /opt/immich/library /opt/navidrome/music /opt/audiobookshelf/audiobooks /opt/audiobookshelf/podcasts /opt/nextcloud/html /opt/nginxproxymanager/data /opt/nginxproxymanager/letsencrypt /opt/startpage/config /opt/vaultwarden/data /opt/hoarder/data /opt/docmost/uploads /opt/docmost/db /opt/octoprint/config /opt/arrfiles/config /opt/arrfiles/database /opt/tautulli/config /opt/overseerr/config /opt/radarr/config /opt/sonarr/config /opt/lidarr/config /opt/bazarr/config /opt/prowlarr/config /opt/qbittorrent/config /opt/media/downloads /opt/nzbget/config /opt/homeassistant/config /opt/zigbee2mqtt/data /opt/frigate/config /opt/frigate/cache /opt/grafana/data /opt/influxdb/data /opt/prometheus/data
        sudo chown -R 1000:1000 /opt/plex /opt/portainer /opt/jellyfin /opt/immich /opt/navidrome /opt/audiobookshelf /opt/nextcloud /opt/nginxproxymanager /opt/startpage /opt/vaultwarden /opt/hoarder /opt/docmost /opt/octoprint /opt/arrfiles /opt/tautulli /opt/overseerr /opt/radarr /opt/sonarr /opt/lidarr /opt/bazarr /opt/prowlarr /opt/qbittorrent /opt/nzbget /opt/homeassistant /opt/zigbee2mqtt /opt/frigate /opt/grafana /opt/influxdb /opt/prometheus /opt/media || true
REMOTE_SCRIPT
    EOT
  }
}

# Deploy Stacks
resource "null_resource" "deploy_stacks" {
  depends_on = [null_resource.bootstrap_docker]

  triggers = {
    docker_host              = var.docker_host
    enable_portainer         = var.enable_portainer
    enable_plex              = var.enable_plex
    enable_jellyfin          = var.enable_jellyfin
    enable_immich            = var.enable_immich
    enable_navidrome         = var.enable_navidrome
    enable_audiobookshelf    = var.enable_audiobookshelf
    enable_nextcloud         = var.enable_nextcloud
    enable_nginxproxymanager = var.enable_nginxproxymanager
    enable_startpage         = var.enable_startpage
    enable_vaultwarden       = var.enable_vaultwarden
    enable_hoarder           = var.enable_hoarder
    enable_docmost           = var.enable_docmost
    enable_octoprint         = var.enable_octoprint
    enable_arrfiles          = var.enable_arrfiles
    enable_tautulli          = var.enable_tautulli
    enable_overseerr         = var.enable_overseerr
    enable_radarr            = var.enable_radarr
    enable_sonarr            = var.enable_sonarr
    enable_lidarr            = var.enable_lidarr
    enable_bazarr            = var.enable_bazarr
    enable_prowlarr          = var.enable_prowlarr
    enable_qbittorrent       = var.enable_qbittorrent
    enable_nzbget            = var.enable_nzbget
    enable_homeassistant     = var.enable_homeassistant
    enable_zigbee2mqtt       = var.enable_zigbee2mqtt
    enable_frigate           = var.enable_frigate
    enable_grafana           = var.enable_grafana
    enable_influxdb          = var.enable_influxdb
    enable_prometheus        = var.enable_prometheus
  }

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
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/nginxproxymanager/docker-compose.yml" "$USER@$HOST:/tmp/nginxproxymanager.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/startpage/docker-compose.yml" "$USER@$HOST:/tmp/startpage.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/vaultwarden/docker-compose.yml" "$USER@$HOST:/tmp/vaultwarden.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/hoarder/docker-compose.yml" "$USER@$HOST:/tmp/hoarder.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/docmost/docker-compose.yml" "$USER@$HOST:/tmp/docmost.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/octoprint/docker-compose.yml" "$USER@$HOST:/tmp/octoprint.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/arrfiles/docker-compose.yml" "$USER@$HOST:/tmp/arrfiles.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/tautulli/docker-compose.yml" "$USER@$HOST:/tmp/tautulli.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/overseerr/docker-compose.yml" "$USER@$HOST:/tmp/overseerr.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/radarr/docker-compose.yml" "$USER@$HOST:/tmp/radarr.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/sonarr/docker-compose.yml" "$USER@$HOST:/tmp/sonarr.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/lidarr/docker-compose.yml" "$USER@$HOST:/tmp/lidarr.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/bazarr/docker-compose.yml" "$USER@$HOST:/tmp/bazarr.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/prowlarr/docker-compose.yml" "$USER@$HOST:/tmp/prowlarr.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/qbittorrent/docker-compose.yml" "$USER@$HOST:/tmp/qbittorrent.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/nzbget/docker-compose.yml" "$USER@$HOST:/tmp/nzbget.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/homeassistant/docker-compose.yml" "$USER@$HOST:/tmp/homeassistant.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/zigbee2mqtt/docker-compose.yml" "$USER@$HOST:/tmp/zigbee2mqtt.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/frigate/docker-compose.yml" "$USER@$HOST:/tmp/frigate.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/grafana/docker-compose.yml" "$USER@$HOST:/tmp/grafana.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/influxdb/docker-compose.yml" "$USER@$HOST:/tmp/influxdb.docker-compose.yml"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "${path.module}/stacks/prometheus/docker-compose.yml" "$USER@$HOST:/tmp/prometheus.docker-compose.yml"

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

        # Wait for containers to finish initial build/health checks
        function wait_for_containers_to_settle {
          local timeout=600
          local interval=5
          local elapsed=0

          while [ $elapsed -lt $timeout ]; do
            local unsettled
            unsettled=$(sudo docker ps -a --format '{{.Names}} {{.Status}}' | \
              grep -v '^portainer ' | \
              grep -E 'health: starting|Restarting|Created' || true)

            if [ -z "$unsettled" ]; then
              echo "Containers have settled."
              return 0
            fi

            echo "Waiting for containers to settle... ($elapsed/$${timeout}s)"
            sleep $interval
            elapsed=$((elapsed + interval))
          done

          echo "Timed out waiting for containers to settle. Proceeding anyway."
          return 1
        }

        # Restart DNS resolver to fix "server misbehaving" errors
        sudo systemctl restart systemd-resolved || true

        # Ensure directories exist (in case bootstrap didn't run or new ones matched)
        sudo mkdir -p /opt/portainer /opt/plex /opt/jellyfin /opt/immich /opt/navidrome /opt/audiobookshelf /opt/nextcloud /opt/nginxproxymanager /opt/startpage /opt/vaultwarden /opt/hoarder /opt/docmost /opt/octoprint /opt/arrfiles /opt/tautulli /opt/overseerr /opt/radarr /opt/sonarr /opt/lidarr /opt/bazarr /opt/prowlarr /opt/qbittorrent /opt/nzbget /opt/homeassistant /opt/zigbee2mqtt /opt/frigate /opt/grafana /opt/influxdb /opt/prometheus /opt/media
        sudo mkdir -p /opt/plex/media /opt/jellyfin/cache /opt/jellyfin/media /opt/immich/library /opt/navidrome/music /opt/audiobookshelf/audiobooks /opt/audiobookshelf/podcasts /opt/nextcloud/html /opt/nginxproxymanager/data /opt/nginxproxymanager/letsencrypt /opt/startpage/config /opt/vaultwarden/data /opt/hoarder/data /opt/docmost/uploads /opt/docmost/db /opt/octoprint/config /opt/arrfiles/config /opt/arrfiles/database /opt/tautulli/config /opt/overseerr/config /opt/radarr/config /opt/sonarr/config /opt/lidarr/config /opt/bazarr/config /opt/prowlarr/config /opt/qbittorrent/config /opt/media/downloads /opt/nzbget/config /opt/homeassistant/config /opt/zigbee2mqtt/data /opt/frigate/config /opt/frigate/cache /opt/grafana/data /opt/influxdb/data /opt/prometheus/data
        sudo chown -R 1000:1000 /opt/plex /opt/portainer /opt/jellyfin /opt/immich /opt/navidrome /opt/audiobookshelf /opt/nextcloud /opt/nginxproxymanager /opt/startpage /opt/vaultwarden /opt/hoarder /opt/docmost /opt/octoprint /opt/arrfiles /opt/tautulli /opt/overseerr /opt/radarr /opt/sonarr /opt/lidarr /opt/bazarr /opt/prowlarr /opt/qbittorrent /opt/nzbget /opt/homeassistant /opt/zigbee2mqtt /opt/frigate /opt/grafana /opt/influxdb /opt/prometheus /opt/media || true

        # Configure Firewall (UFW)
        echo "Configuring Firewall..."
        sudo ufw allow 22/tcp  # SSH
        sudo ufw allow 80/tcp  # HTTP (reverse proxies / direct web access)
        sudo ufw allow 443/tcp # HTTPS (reverse proxies / direct web access)
        sudo ufw allow 81/tcp  # Nginx Proxy Manager admin
        sudo ufw allow 8000/tcp # Portainer
        sudo ufw allow 9000/tcp # Portainer
        sudo ufw allow 3000/tcp # Open WebUI / dashboards
        sudo ufw allow 3002/tcp # Docmost
        sudo ufw allow 3005/tcp # Hoarder
        sudo ufw allow 32400/tcp # Plex
        sudo ufw allow 8096/tcp  # Jellyfin
        sudo ufw allow 8920/tcp  # Jellyfin HTTPS
        sudo ufw allow 2283/tcp  # Immich
        sudo ufw allow 4533/tcp  # Navidrome
        sudo ufw allow 13378/tcp # Audiobookshelf
        sudo ufw allow 8080/tcp  # Nextcloud
        sudo ufw allow 3012/tcp # Vaultwarden WS
        sudo ufw allow 5000/tcp # OctoPrint
        sudo ufw allow 5055/tcp # Overseerr
        sudo ufw allow 6767/tcp # Bazarr
        sudo ufw allow 6789/tcp # NZBGet
        sudo ufw allow 6881/tcp # qBittorrent
        sudo ufw allow 6881/udp # qBittorrent UDP
        sudo ufw allow 7878/tcp # Radarr
        sudo ufw allow 8082/tcp # Vaultwarden HTTP
        sudo ufw allow 8085/tcp # qBittorrent WebUI
        sudo ufw allow 8181/tcp # Tautulli
        sudo ufw allow 8686/tcp # Lidarr
        sudo ufw allow 8989/tcp # Sonarr
        sudo ufw allow 9696/tcp # Prowlarr
        sudo ufw allow 8088/tcp # Arrfiles
        sudo ufw allow 8123/tcp # Home Assistant
        sudo ufw allow 8081/tcp # Zigbee2MQTT
        sudo ufw allow 8971/tcp # Frigate UI
        sudo ufw allow 3001/tcp # Grafana
        sudo ufw allow 8086/tcp # InfluxDB
        sudo ufw allow 9090/tcp # Prometheus
        sudo ufw --force enable || true

        # Move files to correct locations
        sudo mv /tmp/portainer.docker-compose.yml /opt/portainer/docker-compose.yml
        sudo mv /tmp/plex.docker-compose.yml /opt/plex/docker-compose.yml
        sudo mv /tmp/jellyfin.docker-compose.yml /opt/jellyfin/docker-compose.yml
        sudo mv /tmp/immich.docker-compose.yml /opt/immich/docker-compose.yml
        sudo mv /tmp/navidrome.docker-compose.yml /opt/navidrome/docker-compose.yml
        sudo mv /tmp/audiobookshelf.docker-compose.yml /opt/audiobookshelf/docker-compose.yml
        sudo mv /tmp/nextcloud.docker-compose.yml /opt/nextcloud/docker-compose.yml
        sudo mv /tmp/nginxproxymanager.docker-compose.yml /opt/nginxproxymanager/docker-compose.yml
        sudo mv /tmp/startpage.docker-compose.yml /opt/startpage/docker-compose.yml
        sudo mv /tmp/vaultwarden.docker-compose.yml /opt/vaultwarden/docker-compose.yml
        sudo mv /tmp/hoarder.docker-compose.yml /opt/hoarder/docker-compose.yml
        sudo mv /tmp/docmost.docker-compose.yml /opt/docmost/docker-compose.yml
        sudo mv /tmp/octoprint.docker-compose.yml /opt/octoprint/docker-compose.yml
        sudo mv /tmp/arrfiles.docker-compose.yml /opt/arrfiles/docker-compose.yml
        sudo mv /tmp/tautulli.docker-compose.yml /opt/tautulli/docker-compose.yml
        sudo mv /tmp/overseerr.docker-compose.yml /opt/overseerr/docker-compose.yml
        sudo mv /tmp/radarr.docker-compose.yml /opt/radarr/docker-compose.yml
        sudo mv /tmp/sonarr.docker-compose.yml /opt/sonarr/docker-compose.yml
        sudo mv /tmp/lidarr.docker-compose.yml /opt/lidarr/docker-compose.yml
        sudo mv /tmp/bazarr.docker-compose.yml /opt/bazarr/docker-compose.yml
        sudo mv /tmp/prowlarr.docker-compose.yml /opt/prowlarr/docker-compose.yml
        sudo mv /tmp/qbittorrent.docker-compose.yml /opt/qbittorrent/docker-compose.yml
        sudo mv /tmp/nzbget.docker-compose.yml /opt/nzbget/docker-compose.yml
        sudo mv /tmp/homeassistant.docker-compose.yml /opt/homeassistant/docker-compose.yml
        sudo mv /tmp/zigbee2mqtt.docker-compose.yml /opt/zigbee2mqtt/docker-compose.yml
        sudo mv /tmp/frigate.docker-compose.yml /opt/frigate/docker-compose.yml
        sudo mv /tmp/grafana.docker-compose.yml /opt/grafana/docker-compose.yml
        sudo mv /tmp/influxdb.docker-compose.yml /opt/influxdb/docker-compose.yml
        sudo mv /tmp/prometheus.docker-compose.yml /opt/prometheus/docker-compose.yml

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

        if [ -d "/mnt/coldstore" ]; then
            echo "Coldstore detected. Pointing shared media to /mnt/coldstore/media..."
            sudo mkdir -p /mnt/coldstore/media /mnt/coldstore/downloads
            sudo sed -i 's|/opt/media:/data|/mnt/coldstore/media:/data|g' /opt/radarr/docker-compose.yml /opt/sonarr/docker-compose.yml /opt/lidarr/docker-compose.yml /opt/bazarr/docker-compose.yml
            sudo sed -i 's|/opt/media:/srv|/mnt/coldstore/media:/srv|g' /opt/arrfiles/docker-compose.yml
            sudo sed -i 's|/opt/media/downloads:/downloads|/mnt/coldstore/downloads:/downloads|g' /opt/qbittorrent/docker-compose.yml /opt/nzbget/docker-compose.yml
        else
            echo "No coldstore detected. Keeping default /opt/media paths."
        fi

        # Deploy Stacks
        ${var.enable_portainer ? "cd /opt/portainer && (sudo docker rm -f portainer || true) && retry sudo docker compose up -d" : "echo 'Skipping Portainer'"}
        ${var.enable_plex ? "cd /opt/plex && (sudo docker rm -f plex || true) && retry sudo docker compose up -d" : "echo 'Skipping Plex'"}
        ${var.enable_jellyfin ? "cd /opt/jellyfin && (sudo docker rm -f jellyfin || true) && retry sudo docker compose up -d" : "echo 'Skipping Jellyfin'"}
        ${var.enable_immich ? "cd /opt/immich && nohup sudo docker compose up -d > immich.log 2>&1 &" : "echo 'Skipping Immich'"}
        ${var.enable_navidrome ? "cd /opt/navidrome && (sudo docker rm -f navidrome || true) && retry sudo docker compose up -d" : "echo 'Skipping Navidrome'"}
        ${var.enable_audiobookshelf ? "cd /opt/audiobookshelf && (sudo docker rm -f audiobookshelf || true) && retry sudo docker compose up -d" : "echo 'Skipping Audiobookshelf'"}
        ${var.enable_nextcloud ? "cd /opt/nextcloud && (sudo docker rm -f nextcloud nextcloud-db nextcloud-redis || true) && retry sudo docker compose up -d" : "echo 'Skipping Nextcloud'"}
        ${var.enable_nginxproxymanager ? "cd /opt/nginxproxymanager && (sudo docker rm -f nginx-proxy-manager || true) && retry sudo docker compose up -d" : "echo 'Skipping Nginx Proxy Manager'"}
        ${var.enable_startpage ? "cd /opt/startpage && (sudo docker rm -f startpage || true) && retry sudo docker compose up -d" : "echo 'Skipping Startpage'"}
        ${var.enable_vaultwarden ? "cd /opt/vaultwarden && (sudo docker rm -f vaultwarden || true) && retry sudo docker compose up -d" : "echo 'Skipping Vaultwarden'"}
        ${var.enable_hoarder ? "cd /opt/hoarder && (sudo docker rm -f hoarder || true) && retry sudo docker compose up -d" : "echo 'Skipping Hoarder'"}
        ${var.enable_docmost ? "cd /opt/docmost && (sudo docker rm -f docmost docmost-db || true) && retry sudo docker compose up -d" : "echo 'Skipping Docmost'"}
        ${var.enable_octoprint ? "cd /opt/octoprint && (sudo docker rm -f octoprint || true) && retry sudo docker compose up -d" : "echo 'Skipping OctoPrint'"}
        ${var.enable_arrfiles ? "cd /opt/arrfiles && (sudo docker rm -f arrfiles || true) && retry sudo docker compose up -d" : "echo 'Skipping Arrfiles'"}
        ${var.enable_tautulli ? "cd /opt/tautulli && (sudo docker rm -f tautulli || true) && retry sudo docker compose up -d" : "echo 'Skipping Tautulli'"}
        ${var.enable_overseerr ? "cd /opt/overseerr && (sudo docker rm -f overseerr || true) && retry sudo docker compose up -d" : "echo 'Skipping Overseerr'"}
        ${var.enable_radarr ? "cd /opt/radarr && (sudo docker rm -f radarr || true) && retry sudo docker compose up -d" : "echo 'Skipping Radarr'"}
        ${var.enable_sonarr ? "cd /opt/sonarr && (sudo docker rm -f sonarr || true) && retry sudo docker compose up -d" : "echo 'Skipping Sonarr'"}
        ${var.enable_lidarr ? "cd /opt/lidarr && (sudo docker rm -f lidarr || true) && retry sudo docker compose up -d" : "echo 'Skipping Lidarr'"}
        ${var.enable_bazarr ? "cd /opt/bazarr && (sudo docker rm -f bazarr || true) && retry sudo docker compose up -d" : "echo 'Skipping Bazarr'"}
        ${var.enable_prowlarr ? "cd /opt/prowlarr && (sudo docker rm -f prowlarr || true) && retry sudo docker compose up -d" : "echo 'Skipping Prowlarr'"}
        ${var.enable_qbittorrent ? "cd /opt/qbittorrent && (sudo docker rm -f qbittorrent || true) && retry sudo docker compose up -d" : "echo 'Skipping qBittorrent'"}
        ${var.enable_nzbget ? "cd /opt/nzbget && (sudo docker rm -f nzbget || true) && retry sudo docker compose up -d" : "echo 'Skipping NZBGet'"}
        ${var.enable_homeassistant ? "cd /opt/homeassistant && (sudo docker rm -f homeassistant || true) && retry sudo docker compose up -d" : "echo 'Skipping Home Assistant'"}
        ${var.enable_zigbee2mqtt ? "cd /opt/zigbee2mqtt && (sudo docker rm -f zigbee2mqtt || true) && retry sudo docker compose up -d" : "echo 'Skipping Zigbee2MQTT'"}
        ${var.enable_frigate ? "cd /opt/frigate && (sudo docker rm -f frigate || true) && retry sudo docker compose up -d" : "echo 'Skipping Frigate'"}
        ${var.enable_grafana ? "cd /opt/grafana && (sudo docker rm -f grafana || true) && retry sudo docker compose up -d" : "echo 'Skipping Grafana'"}
        ${var.enable_influxdb ? "cd /opt/influxdb && (sudo docker rm -f influxdb || true) && retry sudo docker compose up -d" : "echo 'Skipping InfluxDB'"}
        ${var.enable_prometheus ? "cd /opt/prometheus && (sudo docker rm -f prometheus || true) && retry sudo docker compose up -d" : "echo 'Skipping Prometheus'"}

        # Pause all containers except Portainer after they have settled
        wait_for_containers_to_settle || true
        NON_PORTAINER_CONTAINERS=$(sudo docker ps --format '{{.Names}}' | grep -v '^portainer$' || true)

        if [ -n "$NON_PORTAINER_CONTAINERS" ]; then
          echo "Pausing non-Portainer containers: $NON_PORTAINER_CONTAINERS"
          echo "$NON_PORTAINER_CONTAINERS" | xargs -r sudo docker pause
        else
          echo "No non-Portainer containers are running to pause."
        fi
REMOTE_SCRIPT
    EOT
  }
}
