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
    audiobookshelf/ immich/ jellyfin/ navidrome/ nextcloud/ ollama/ plex/ portainer/
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
     -var="enable_ollama=true" \
     -var="enable_plex=true" \
     -var="enable_jellyfin=true" \
     -var="enable_immich=true" \
    -var="enable_navidrome=true" \
    -var="enable_audiobookshelf=true" \
    -var="enable_nextcloud=true" \
    -var="enable_ai_extras=true"
   ```

   **Note:** replace `192.168.86.38` with your actual server IP.

2. **Accessing Media & Tools:**
   * **Portainer:** `http://<server-ip>:9000`
   * **Ollama/Open WebUI:** `http://<server-ip>:3000` (if enabled)
   * **Plex:** `http://<server-ip>:32400/web`
   * **Jellyfin:** `http://<server-ip>:8096`
   * **Immich:** `http://<server-ip>:2283`
   * **Navidrome:** `http://<server-ip>:4533`
   * **Audiobookshelf:** `http://<server-ip>:13378`
   * **Nextcloud:** `http://<server-ip>:8080`
   * **AI Extras stack (all-in-one optional sandbox):**
     * Text Generation WebUI: `http://<server-ip>:7860`
     * LibreChat (plus Mongo/Redis/Meilisearch backing services): `http://<server-ip>:3080`
     * ComfyUI: `http://<server-ip>:8188`
     * Stable Diffusion WebUI (LinuxServer): `http://<server-ip>:7861`
     * Whisper.cpp server: `http://<server-ip>:9000`
     * Piper TTS (Wyoming): `http://<server-ip>:10200`
     * Qdrant: `http://<server-ip>:6333`
     * Milvus standalone: `http://<server-ip>:9091`
     * LangGraph Studio: `http://<server-ip>:8123`
     * CrewAI orchestrator: `http://<server-ip>:8001`

   Terraform's remote bootstrap automatically opens UFW for HTTP/HTTPS (80/443), Open WebUI (3000), and every published media port above so the services bind to `0.0.0.0` and remain reachable externally.

   Media stacks auto-mount `/mnt/coldstore` for their libraries if that directory exists; otherwise they fall back to the default `/opt/<service>` paths included in the Compose files.

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
