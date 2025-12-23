# Home Gaming Server Infrastructure

This project manages a home server running various Docker stacks using Terraform, with a focus on self-hosted game servers plus a few media/tooling containers.

## Project Structure
```
infra/            # Terraform configuration
  bootstrap.sh    # Manual bootstrap script (optional)
  main.tf         # Main Terraform logic
  variables.tf    # Variable definitions
  outputs.tf      # Deployment outputs
  stacks/         # Docker Compose files grouped by purpose
    # Game servers
    ark/ cs2/ minecraft/ rust/ tf2/ garrysmod/ insurgency_sandstorm/ squad/ squad44/
    satisfactory/ factorio/ eco/ space_engineers/ starbound/ aoe2de/ palworld/ arma3/
    # Media & tooling
    portainer/ ollama/ plex/
```

## Deployment

1. **Bootstrap and Deploy:**
   Run Terraform from the `infra/` directory. This will bootstrap the server (install Docker) and deploy your selected stacks.

   ```bash
   cd infra
   terraform init
   terraform apply \
     -var="docker_host=ssh://michael@192.168.86.38" \
     -var="cs2_gslt=YOUR_STEAM_TOKEN" \
     -var="enable_portainer=true" \
     -var="enable_ollama=true" \
     -var="enable_plex=true" \
     -var="enable_rust=true" \
     -var="enable_ark=true" \
     -var="enable_cs2=true" \
     -var="enable_minecraft=true" \
     -var="enable_tf2=true" \
     -var="enable_garrysmod=true" \
     -var="enable_insurgency_sandstorm=true" \
     -var="enable_squad=true" \
     -var="enable_squad44=true" \
     -var="enable_satisfactory=true" \
     -var="enable_factorio=true" \
     -var="enable_eco=true" \
     -var="enable_space_engineers=true" \
     -var="enable_starbound=true" \
     -var="enable_aoe2de=true" \
     -var="enable_palworld=true" \
     -var="enable_arma3=true"
   ```

   **Note:** replace `192.168.86.38` with your actual server IP.

2. **Accessing Media & Tools:**
   * **Portainer:** `http://<server-ip>:9000`
   * **Ollama/Open WebUI:** `http://<server-ip>:3000` (if enabled)
   * **Plex:** `http://<server-ip>:32400/web`

3. **Game Server Catalog & Connection Info:**
   * **Rust** — Hardcore multiplayer survival with base building and community-run servers (very popular for self-hosting). Connect to `<server-ip>:28015` (game) and `<server-ip>:28016` (RCON).
   * **ARK: Survival Evolved** — Dino taming + tribe survival; widely self-hosted with lots of server settings/mods. Connect to `<server-ip>:7777` (UDP game) / `<server-ip>:27016` (query).
   * **Counter-Strike 2** — Competitive tactical FPS; you can run your own community server and control maps/modes. Connect to `<server-ip>:27015` (TCP/UDP).
   * **Minecraft** — Classic sandbox builder; easy to self-host for friends. Connect to `<server-ip>:25565`.
   * **Team Fortress 2** — Class-based team shooter; community servers remain a major way to play. Connect to `<server-ip>:27015` (TCP/UDP).
   * **Garry’s Mod** — Physics sandbox with many multiplayer gamemodes that are typically hosted on community servers. Connect to `<server-ip>:27015` (TCP/UDP) and `<server-ip>:27005` (UDP).
   * **Insurgency: Sandstorm** — Tactical modern FPS; supports hosted servers for co-op and PvP. Connect to `<server-ip>:27102` (game UDP) and `<server-ip>:27131` (query UDP).
   * **Squad** — 100-player teamwork/milsim-style FPS; dedicated servers are the standard for communities. Connect to `<server-ip>:7787` (game UDP) / `<server-ip>:27165` (query UDP).
   * **Squad 44** — WWII large-scale tactical FPS (formerly Post Scriptum); typically played on community servers. Connect to `<server-ip>:10027` (game UDP) / `<server-ip>:10037` (query UDP).
   * **Satisfactory** — First-person factory building; dedicated servers are common for persistent worlds with friends. Connect to `<server-ip>:7777`, `<server-ip>:15000`, `<server-ip>:15777` (UDP).
   * **Factorio** — Automation/factory game; great for always-on servers (headless server is common). Connect to `<server-ip>:34197` (UDP) / `<server-ip>:27015` (TCP).
   * **Eco** — Build a civilization without wrecking the ecosystem; includes a server package for hosting worlds. Connect to `<server-ip>:3000` (TCP) / `<server-ip>:3001` (UDP).
   * **Space Engineers** — Engineering/sandbox building in space; strong community server ecosystem. Connect to `<server-ip>:27016` (UDP) / `<server-ip>:8766` (UDP).
   * **Starbound** — 2D space exploration/sandbox with multiplayer hosting possibilities. Connect to `<server-ip>:21025` (TCP).
   * **Age of Empires II: Definitive Edition** — Classic RTS; great for multiplayer sessions. Connect to `<server-ip>:27015` (UDP) / `<server-ip>:27016` (UDP).
   * **Palworld** — Open-world crafting with “Pals”; dedicated servers are common for groups. Connect to `<server-ip>:8211` (UDP) / `<server-ip>:27015` (UDP).
   * **Arma 3** — Military sandbox; extremely common to run dedicated servers for custom missions/modpacks. Connect to `<server-ip>:2302-2305` (UDP).

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
