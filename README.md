# home-server
Deploying docker containers to home server

## Overview

This repository contains Terraform configurations to bootstrap and deploy Docker Compose stacks for various services on a home server.

## Available Stacks

- **Portainer**: Container management UI (enabled by default)
- **Ollama**: Large language model runtime
- **Rust**: Rust game server
- **ARK**: ARK Survival Ascended game server
- **CS2**: Counter-Strike 2 game server

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- Docker daemon running on the target host
- Docker socket accessible at `/var/run/docker.sock` (or configure custom host)

## Quick Start

1. Navigate to the infrastructure directory:
   ```bash
   cd infra
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the planned changes:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

## Configuration

### Enabling/Disabling Stacks

By default, only Portainer is enabled. You can enable other stacks by setting variables:

```bash
# Enable specific stacks
terraform apply -var="enable_ollama=true" -var="enable_rust=true"
```

Or create a `terraform.tfvars` file in the `infra` directory:

```hcl
enable_portainer = true
enable_ollama    = true
enable_rust      = false
enable_ark       = false
enable_cs2       = false
```

### Custom Docker Host

If your Docker daemon is running on a different host or socket:

```bash
terraform apply -var="docker_host=tcp://192.168.1.100:2375"
```

## Available Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `docker_host` | Docker daemon socket to connect to | `unix:///var/run/docker.sock` |
| `enable_portainer` | Enable Portainer stack deployment | `true` |
| `enable_ollama` | Enable Ollama stack deployment | `false` |
| `enable_rust` | Enable Rust server stack deployment | `false` |
| `enable_ark` | Enable ARK server stack deployment | `false` |
| `enable_cs2` | Enable CS2 server stack deployment | `false` |
| `ark_server_password` | ARK server password (leave empty for no password) | `""` (sensitive) |
| `ark_admin_password` | ARK server admin password | `"change-me-admin-pass"` (sensitive) |
| `cs2_gslt` | CS2 Game Server Login Token from Steam | `""` (sensitive) |

### Important Security Notes

- **ARK Server**: Change the default `ark_admin_password` before deploying to production
- **CS2 Server**: Obtain a Game Server Login Token (GSLT) from [Steam Game Server Account Management](https://steamcommunity.com/dev/managegameservers)
- All sensitive variables are marked as sensitive and will not be displayed in Terraform output

## Outputs

After successful deployment, Terraform will output:

- URLs for web-accessible services
- Connection ports for game servers
- List of deployed stacks

View outputs anytime with:
```bash
terraform output
```

## Managing the Infrastructure

### Updating Stacks

Modify variables and reapply:
```bash
terraform apply
```

### Destroying Stacks

Remove all deployed containers and volumes:
```bash
terraform destroy
```

Remove specific stacks by disabling them:
```bash
terraform apply -var="enable_rust=false"
```

## Docker Compose Files

Each stack has a corresponding `docker-compose.yml` file in `infra/stacks/` for reference and manual deployment if needed:

- `infra/stacks/portainer/docker-compose.yml`
- `infra/stacks/ollama/docker-compose.yml`
- `infra/stacks/rust/docker-compose.yml`
- `infra/stacks/ark/docker-compose.yml`
- `infra/stacks/cs2/docker-compose.yml`

## Troubleshooting

### Permission Issues

Ensure your user has access to the Docker socket:
```bash
sudo usermod -aG docker $USER
```

### Port Conflicts

Check if ports are already in use:
```bash
sudo netstat -tlnp | grep <port_number>
```

### View Container Logs

Once Portainer is deployed, access it at `http://localhost:9000` to manage and view logs for all containers.
