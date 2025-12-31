# Home Server

This project manages a home server running various Docker stacks using Terraform, with a focus on self-hosted media and tooling containers.

## Project Structure
```
infra/            # Terraform configuration
  bootstrap.sh    # Manual bootstrap script (optional)
  main.tf         # Main Terraform logic
  variables.tf    # Variable definitions
  outputs.tf      # Deployment outputs
  stacks/         # Docker Compose files grouped by purpose
    # Media & tooling
    audiobookshelf/ bazarr/ docmost/ frigate/ grafana/ hoarder/ homeassistant/ immich/ influxdb/
    jellyfin/ lidarr/ navidrome/ nextcloud/ nginxproxymanager/ nzbget/ octoprint/ overseerr/
    plex/ portainer/ prometheus/ prowlarr/ qbittorrent/ radarr/ sonarr/ startpage/ tautulli/
    vaultwarden/ zigbee2mqtt/
```

## Deployment

1. **Bootstrap and Deploy:**
   Run Terraform from the `infra/` directory. This will bootstrap the server (install Docker) and deploy your selected stacks.

   ```bash
   cd infra
   terraform init
   terraform apply \
     -var="docker_host=ssh://michael@192.168.86.38" \
     -var="enable_portainer=true" \
     -var="enable_plex=true" \
     -var="enable_jellyfin=true" \
     -var="enable_immich=true" \
     -var="enable_navidrome=true" \
     -var="enable_audiobookshelf=true" \
     -var="enable_overseerr=true" \
     -var="enable_radarr=true" \
     -var="enable_sonarr=true" \
     -var="enable_lidarr=true" \
     -var="enable_bazarr=true" \
     -var="enable_prowlarr=true" \
     -var="enable_qbittorrent=true" \
     -var="enable_nzbget=true" \
     -var="enable_nginxproxymanager=true" \
     -var="enable_homeassistant=true" \
     -var="enable_zigbee2mqtt=true" \
     -var="enable_frigate=true" \
     -var="enable_grafana=true" \
     -var="enable_influxdb=true" \
     -var="enable_prometheus=true" \
     -var="enable_nextcloud=true"
  ```

   **Note:** replace `192.168.86.38` with your actual server IP.

2. **Accessing Media & Tools:**
  * **Media & Productivity:**
    * **Portainer:** `http://<server-ip>:9000`
    * **Plex:** `http://<server-ip>:32400/web`
    * **Jellyfin:** `http://<server-ip>:8096`
    * **Immich:** `http://<server-ip>:2283`
    * **Navidrome:** `http://<server-ip>:4533`
    * **Audiobookshelf:** `http://<server-ip>:13378`
    * **Homepage (startpage):** `http://<server-ip>:3000`
    * **Vaultwarden:** `http://<server-ip>:8082` (Admin via `ADMIN_TOKEN` env var)
    * **Hoarder:** `http://<server-ip>:3005`
    * **Docmost:** `http://<server-ip>:3002`
    * **OctoPrint:** `http://<server-ip>:5000`
    * **Nextcloud:** `http://<server-ip>:8080`
    * **Nginx Proxy Manager:** `http://<server-ip>:81` (admin UI)
    * **File Browser (Arrfiles):** `http://<server-ip>:8088`
    * **Tautulli:** `http://<server-ip>:8181`
    * **Overseerr:** `http://<server-ip>:5055`
    * **Radarr:** `http://<server-ip>:7878`
    * **Sonarr:** `http://<server-ip>:8989`
    * **Lidarr:** `http://<server-ip>:8686`
    * **Bazarr:** `http://<server-ip>:6767`
    * **Prowlarr:** `http://<server-ip>:9696`
    * **qBittorrent:** `http://<server-ip>:8085`
    * **NZBGet:** `http://<server-ip>:6789`
    * **Home Assistant:** `http://<server-ip>:8123`
    * **Zigbee2MQTT:** `http://<server-ip>:8081`
    * **Frigate:** `http://<server-ip>:8971`
    * **Grafana:** `http://<server-ip>:3001`
    * **InfluxDB:** `http://<server-ip>:8086`
    * **Prometheus:** `http://<server-ip>:9090`
   Terraform's remote bootstrap automatically opens UFW for HTTP/HTTPS (80/443) and the ports associated with any services you enable so they bind to `0.0.0.0` and remain reachable externally.

   Media stacks auto-mount `/mnt/coldstore` for their libraries if that directory exists; otherwise they fall back to the default `/opt/<service>` paths included in the Compose files.

## What Each Service Provides

### Media & Productivity
* **Portainer:** Web UI for monitoring the Docker host, viewing logs, and updating containers.
* **Plex:** Personal media server with rich clients for TVs and mobile devices.
* **Jellyfin:** Open-source alternative to Plex for streaming movies and TV shows.
* **Immich:** Self-hosted photo and video backup with mobile apps and face/object search.
* **Navidrome:** Music streaming server compatible with Subsonic clients.
* **Audiobookshelf:** Audiobook and podcast library with bookmarking and progress sync.
* **Nextcloud:** File sync/share suite with calendar, contacts, and productivity add-ons.
* **Homepage (startpage):** Personalizable start page for quick links and dashboards.
* **Vaultwarden:** Lightweight Bitwarden-compatible password manager.
* **Hoarder:** Bookmarking and content archiving service.
* **Docmost:** Collaborative documentation with rich editing and Postgres-backed storage.
* **OctoPrint:** Web UI for managing and monitoring 3D printer jobs.
* **Nginx Proxy Manager:** Point-and-click reverse proxy, SSL, and access management for hosted apps.
* **Arrfiles (File Browser):** Web-based file manager for the shared media directory.
* **Tautulli:** Plex activity monitoring and analytics.
* **Overseerr:** Media request portal that integrates with the *arr ecosystem.
* **Radarr/Sonarr/Lidarr:** Automate movie, series, and music library downloads.
* **Bazarr:** Subtitle management that pairs with Radarr/Sonarr.
* **Prowlarr:** Indexer manager to feed Radarr/Sonarr/Lidarr with torrent/NZB sources.
* **qBittorrent & NZBGet:** Download clients for torrents and Usenet.
* **Home Assistant:** Smart home automation hub compatible with a wide range of devices.
* **Zigbee2MQTT:** Zigbee coordinator/bridge with web UI for managing Zigbee devices.
* **Frigate:** NVR for IP cameras with object detection and clip storage.
* **Grafana:** Dashboards and visualizations for metrics.
* **InfluxDB:** Time-series database for storing telemetry.
* **Prometheus:** Metrics collection and alerting toolkit.

## System Prerequisites
Before running Terraform, you must ensure:
1.  **SSH Access:** Keys are copied to the server (`ssh-copy-id`).
2.  **Passwordless Sudo:** The user must be able to run sudo without a password for Terraform automation.
    Run this on the server (or via SSH) once:
    ```bash
    ssh -t michael@<server-ip> "echo 'michael ALL=(ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/michael"
    ```

## Bootstrapping Details
Terraform uses SSH to connect to the server. Ensure you have:
1. SSH access to the server via public key (`ssh-copy-id`).
2. Sudo privileges on the server (NOPASSWD recommended).

## Checking Logs
To check on the logs of the deployed services (example: Portainer), you can SSH into the server and run the docker logs command:

```bash
ssh michael@192.168.86.38 "sudo docker logs -f portainer"
```
