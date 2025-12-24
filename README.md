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
    portainer/ ollama/ plex/ jellyfin/ immich/ navidrome/ audiobookshelf/ nextcloud/
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
     -var="enable_jellyfin=true" \
     -var="enable_immich=true" \
     -var="enable_navidrome=true" \
     -var="enable_audiobookshelf=true" \
     -var="enable_nextcloud=true" \
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
   * **Jellyfin:** `http://<server-ip>:8096`
   * **Immich:** `http://<server-ip>:2283`
   * **Navidrome:** `http://<server-ip>:4533`
   * **Audiobookshelf:** `http://<server-ip>:13378`
   * **Nextcloud:** `http://<server-ip>:8080`

   Terraform's remote bootstrap automatically opens UFW for HTTP/HTTPS (80/443), Open WebUI (3000), and every published media port above so the services bind to `0.0.0.0` and remain reachable externally.

   Media stacks auto-mount `/mnt/coldstore` for their libraries if that directory exists; otherwise they fall back to the default `/opt/<service>` paths included in the Compose files.

3. **Game Server Catalog & Connection Info:** (links go to the official game pages and the ports reflect the Terraform Docker Compose stacks.)

   | Game | Ports to Expose (host side) | How to Join from the Game Client |
   | --- | --- | --- |
   | [Rust](https://rust.facepunch.com/) | Game: `<server-ip>:28015`, RCON: `<server-ip>:28016` | Press ``F1`` to open the console, run `connect <server-ip>:28015`, and use RCON tools pointed at port 28016 if needed. |
   | [ARK: Survival Evolved](https://store.steampowered.com/app/346110/ARK_Survival_Evolved/) | Game UDP: `<server-ip>:7777`, Alt UDP: `<server-ip>:7778`, Query UDP: `<server-ip>:27016` | In **Join ARK**, add the server to favorites with `steam://connect/<server-ip>:7777` or via the in-game favorites list using the game port (7777). |
   | [Counter-Strike 2](https://store.steampowered.com/app/730/CounterStrike_2/) | TCP/UDP: `<server-ip>:27015` | In the developer console, run `connect <server-ip>:27015`, or add the IP/port under Community Servers > Favorites. |
   | [Minecraft](https://www.minecraft.net/) | TCP: `<server-ip>:25565` | From Multiplayer, choose **Direct Connection** or **Add Server** and enter `<server-ip>` (port 25565). |
   | [Team Fortress 2](https://store.steampowered.com/app/440/Team_Fortress_2/) | TCP/UDP: `<server-ip>:27017` | Open **Browse Servers** → **Favorites** → **Add a Server**, enter `<server-ip>:27017`, then connect. |
   | [Garry’s Mod](https://store.steampowered.com/app/4000/Garrys_Mod/) | TCP/UDP: `<server-ip>:27018`, Extra UDP: `<server-ip>:27008` | In the main menu, open **Find Multiplayer Game** → **Legacy Browser** → **Favorites**, add `<server-ip>:27018`, then connect. |
   | [Insurgency: Sandstorm](https://store.steampowered.com/app/581320/Insurgency_Sandstorm/) | Game UDP: `<server-ip>:27102`, Query UDP: `<server-ip>:27131` | From the Play menu, use the server browser Filters → Favorites, add `<server-ip>:27102`, then refresh and join. |
   | [Squad](https://joinsquad.com/) | Game UDP: `<server-ip>:7787`, Query UDP: `<server-ip>:27165` | In the server browser, open **Favorites**, click **Add Server**, input `<server-ip>:7787`, refresh, and connect. |
   | [Squad 44 (Post Scriptum)](https://store.steampowered.com/app/736220/Post_Scriptum/) | Game UDP: `<server-ip>:10027`, Query UDP: `<server-ip>:10037` | Use the in-game server browser Favorites tab, add `<server-ip>:10027`, refresh, and join. |
   | [Satisfactory](https://www.satisfactorygame.com/) | UDP: `<server-ip>:7779`, `<server-ip>:15000`, `<server-ip>:15777` | From the main menu choose **Server Manager** → **Add Server**, enter `<server-ip>`, set port to `7779`, then authenticate when prompted; additional ports are handled automatically. |
   | [Factorio](https://factorio.com/) | Game UDP: `<server-ip>:34197`, RCON TCP: `<server-ip>:27022` | In Multiplayer → Connect to address, enter `<server-ip>:34197`; use RCON tools against port 27022 if configured. |
   | [Eco](https://store.steampowered.com/app/382310/Eco/) | TCP: `<server-ip>:3000`, UDP: `<server-ip>:3001` | From the main menu, open **Your Worlds** → **Join**, enter `<server-ip>:3000`, and connect. |
   | [Space Engineers](https://store.steampowered.com/app/244850/Space_Engineers/) | UDP: `<server-ip>:27019`, `<server-ip>:8766` | In the Join Game menu, switch to **Favorites**, add `<server-ip>:27019`, and connect after it appears. |
   | [Starbound](https://store.steampowered.com/app/211820/Starbound/) | TCP: `<server-ip>:21025` | From the main menu, click **Join Game**, enter `<server-ip>` and port `21025`, then join. |
   | [Age of Empires II: Definitive Edition](https://www.ageofempires.com/games/aoeiide/) | UDP: `<server-ip>:27020`, `<server-ip>:27021` | Create or join a **Custom/LAN** lobby and direct connect to `<server-ip>:27020`; keep query port 27021 open for lobby visibility. |
   | [Palworld](https://store.steampowered.com/app/1623730/PALWORLD/) | UDP: `<server-ip>:8211`, Query UDP: `<server-ip>:27023` | In **Join Multiplayer** enter `<server-ip>:8211` (or share an invite code if enabled); keep query port 27023 open for listings. |
   | [Arma 3](https://store.steampowered.com/app/107410/Arma_3/) | UDP: `<server-ip>:2302-2305` | From the Launcher server browser, add `<server-ip>` to Favorites (default port 2302), refresh, and connect; ensure 2303-2305 remain open for Steam queries. |

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
