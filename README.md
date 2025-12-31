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
    audiobookshelf/ immich/ jellyfin/ navidrome/ nextcloud/ plex/ portainer/
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
     * **Nextcloud:** `http://<server-ip>:8080`
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
