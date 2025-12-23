# Home Server Infrastructure

This project manages a home server running various Docker stacks using Terraform.

## Project Structure
```
infra/            # Terraform configuration
  bootstrap.sh    # Manual bootstrap script (optional)
  main.tf         # Main Terraform logic
  variables.tf    # Variable definitions
  outputs.tf      # Deployment outputs
  stacks/         # Docker Compose files
    portainer/
    ollama/
    rust/
    ark/
    cs2/
    minecraft/
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
     -var="enable_cs2=true" \
     -var="enable_ark=true" \
     -var="enable_rust=true" \
     -var="enable_minecraft=true"
   ```

   **Note:** replace `192.168.86.38` with your actual server IP.

2. **Accessing Services:**
   * **Portainer:** `http://<server-ip>:9000`
   * **Ollama/Open WebUI:** `http://<server-ip>:3000` (if enabled)
   * **CS2:** Connect via Steam to `<server-ip>:27015`
   * **ARK:** Connect via Steam to `<server-ip>:7777` (UDP)
   * **Rust:** Connect via Steam to `<server-ip>:28015`
   * **Minecraft:** Connect via Minecraft to `<server-ip>:25565`

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
