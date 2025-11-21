# Omarchy Supplement

Personal supplemental installation and configuration scripts for [Omarchy](https://omarchy.com) - a curated Arch Linux distribution with Hyprland.

## Overview

This repository contains automated setup scripts to extend Omarchy with additional tools, customized configurations, and development environments. It follows the [Omarchy configuration philosophy](https://learn.omacom.io/2/the-omarchy-manual/65/dotfiles) of keeping user customizations in `~/.config` while preserving core Omarchy files.

## What's Included

### Core Tools
- **Zsh** - Z shell with modern features
- **mise** - Fast, polyglot version manager (replaces asdf)
- **Ghostty** - Modern, GPU-accelerated terminal emulator
- **tmux** - Terminal multiplexer with plugin manager (TPM)
- **stow** - Symlink farm manager for dotfiles

### Development Environments
- **Node.js** (v22 LTS) - JavaScript/TypeScript runtime
- **Ruby** (v3.4.7) - Ruby programming language
- **PostgreSQL** - Relational database with user setup

### DevOps Tools
- **kubectl** - Kubernetes command-line tool
- **kubectx** - Fast Kubernetes context switcher
- **helm** - Kubernetes package manager
- **k9s** - Kubernetes TUI (Terminal UI)
- **terraform** - Infrastructure as Code tool
- **ansible** - Configuration management and automation
- **aws-cli** - Amazon Web Services CLI
- **gcloud** - Google Cloud Platform CLI
- **azure-cli** - Microsoft Azure CLI

### Customizations
- **Dotfiles** - Pre-configured from [typecraft-dev/dotfiles](https://github.com/typecraft-dev/dotfiles)
  - Neovim configuration
  - Ghostty terminal config (Catppuccin Mocha theme)
  - tmux configuration
  - Starship prompt
  - Zsh configuration

- **Hyprland Overrides** - Custom keybindings and window manager settings
  - Ghostty as default terminal
  - Chromium with custom scaling
  - Vim-style focus navigation (hjkl)
  - Monitor management for laptops
  - Custom app launchers (Discord, Notion)

## Prerequisites

- **Omarchy** must be installed and running
- **yay** AUR helper (included with Omarchy)
- Internet connection for downloading packages

## Quick Start

### Full Installation

Clone the repository and run the complete installation:

```bash
git clone <your-repo-url> ~/projects/omarchy-supplement
cd ~/projects/omarchy-supplement
chmod +x *.sh
./install-all.sh
```

The installation script is **idempotent** - it will only install components that are missing, so you can safely run it multiple times.

After installation completes, **log out and log back in** for all changes to take effect.

### Individual Installations

You can also install components individually:

```bash
# Version manager (required for Node.js and Ruby)
./install-asdf.sh        # Installs mise

# Development tools
./install-nodejs.sh      # Node.js v22 LTS
./install-ruby.sh        # Ruby 3.4.7
./install-postgresql.sh  # PostgreSQL database

# DevOps tools
./install-devops-tools.sh  # kubectl, helm, terraform, k9s, cloud CLIs

# Terminal and shell
./install-ghostty.sh     # Ghostty terminal
./install-tmux.sh        # tmux + TPM
./install-zsh.sh         # Zsh shell
./set-shell.sh           # Set Zsh as default

# Dotfiles and configs
./install-stow.sh        # GNU stow
./install-dotfiles.sh    # Clone and apply dotfiles
./install-hyprland-overrides.sh  # Hyprland customizations
```

All installation scripts are **idempotent** and can be run multiple times safely.

## Configuration Details

### Omarchy Configuration Philosophy

Omarchy separates user configurations from system files:
- **User configs**: `~/.config/` (your customizations)
- **System files**: `~/.local/share/omarchy/` (Omarchy's defaults)

Always modify files in `~/.config/` to preserve your changes across Omarchy updates.

### Hyprland Overrides

The `hyprland-overrides.conf` file is sourced by Hyprland and contains:

**Terminal & Browser:**
- `SUPER + RETURN` - Launch Ghostty terminal
- `SUPER + B` - Launch Chromium browser (0.8 scale)

**App Shortcuts:**
- `SUPER + D` - Discord web app
- `SUPER + G` - Notion

**Window Navigation (Vim-style):**
- `SUPER + h/j/k/l` - Focus left/down/up/right

**Monitor Management:**
- `SUPER + SHIFT + D` - Disable built-in display
- `SUPER + SHIFT + F` - Enable built-in display
- Automatic lid switch handling

### Ghostty Configuration

Located at `~/.config/ghostty/config` (symlinked from dotfiles):
- **Theme**: Catppuccin Mocha
- **Font size**: 14pt
- **Background opacity**: 0.95
- **GTK titlebar**: Disabled

### Version Management with mise

The `.tool-versions` file in your home directory specifies tool versions:

```
nodejs 25.2.1
ruby 3.4.7
```

**Common mise commands:**
```bash
mise install              # Install all tools from .tool-versions
mise install nodejs@22    # Install specific version
mise use nodejs@22        # Set version for current directory
mise use -g nodejs@22     # Set version globally
mise list                 # Show installed versions
mise current              # Show active versions
```

### DevOps Tools Setup

After installing the DevOps tools, you'll need to configure the cloud CLIs:

**AWS CLI:**
```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, region, and output format
```

**Google Cloud CLI:**
```bash
gcloud init
# Follow the interactive setup to authenticate and select project
```

**Azure CLI:**
```bash
az login
# Opens browser for authentication
az account list  # List available subscriptions
az account set --subscription <subscription-id>
```

**Kubernetes:**
```bash
kubectl config view              # View current config
kubectl config get-contexts      # List available contexts
kubectx                          # Switch contexts easily
k9s                              # Launch Kubernetes TUI
```

**Terraform:**
```bash
terraform init    # Initialize working directory
terraform plan    # Preview changes
terraform apply   # Apply changes
```

## Customizing Configurations

### Modify Hyprland Settings

Edit your overrides file:
```bash
nano ~/projects/omarchy-supplement/hyprland-overrides.conf
```

Then reload Hyprland:
```bash
hyprctl reload
```

### Modify Dotfiles

Dotfiles are managed via stow. To customize:

1. Navigate to dotfiles:
   ```bash
   cd ~/dotfiles
   ```

2. Edit the desired configuration in the appropriate directory
   - `ghostty/.config/ghostty/config` - Terminal config
   - `nvim/.config/nvim/` - Neovim config
   - `tmux/.config/tmux/` - tmux config
   - `starship/.config/starship.toml` - Prompt config
   - `zshrc/.zshrc` - Zsh config

3. Changes are immediately applied (symlinks)

### Modify Shell Configuration

Personal shell customizations should go in `~/.bashrc` or `~/.zshrc`, which won't be overwritten during Omarchy updates.

## Troubleshooting

### Theme Error: "catppuccin-mocha not found"

**Solution:** Ghostty 1.2.0 changed theme names to Title Case.

Edit `~/.config/ghostty/config`:
```
theme = Catppuccin Mocha  # Correct (Title Case)
```

Not:
```
theme = catppuccin-mocha  # Old format (deprecated)
```

### Multiple Terminals Launch on SUPER + RETURN

**Cause:** Conflicting keybindings between system config and overrides.

**Solution:** Modify the terminal variable in `~/.config/hypr/bindings.conf` directly:
```
$terminal = uwsm-app -- ghostty
```

Don't try to override with `unbind` - edit the file directly per Omarchy philosophy.

### mise: "missing: ruby@3.4.7" or "missing: nodejs@..."

**Solution:** Install the missing tool version:
```bash
mise install ruby@3.4.7
# or
mise install  # Install all from .tool-versions
```

### PostgreSQL Connection Issues

Ensure the service is running:
```bash
sudo systemctl status postgresql
sudo systemctl start postgresql
```

Connect to database:
```bash
psql  # Connects to your user database
```

### Ghostty Not Launching

Check if it's installed:
```bash
which ghostty
ghostty --version
```

Reinstall if needed:
```bash
yay -S ghostty
```

## File Structure

```
omarchy-supplement/
├── install-all.sh              # Master installation script (idempotent)
├── install-asdf.sh             # Install mise version manager
├── install-nodejs.sh           # Install Node.js via mise
├── install-ruby.sh             # Install Ruby via mise
├── install-postgresql.sh       # Install and configure PostgreSQL
├── install-devops-tools.sh     # Install kubectl, helm, terraform, etc.
├── install-ghostty.sh          # Install Ghostty terminal
├── install-tmux.sh             # Install tmux + TPM
├── install-zsh.sh              # Install Zsh
├── install-stow.sh             # Install GNU stow
├── install-dotfiles.sh         # Clone and apply dotfiles
├── install-hyprland-overrides.sh  # Apply Hyprland customizations
├── set-shell.sh                # Set Zsh as default shell
├── hyprland-overrides.conf     # Custom Hyprland keybindings/settings
└── README.md                   # This file
```

## Version Information

### Development Tools
- **Node.js**: 25.2.1 (specified in ~/.tool-versions)
- **Ruby**: 3.4.7 (specified in ~/.tool-versions)
- **PostgreSQL**: Latest stable from Arch repos
- **mise**: Latest from https://mise.run

### Terminal & Shell
- **Ghostty**: Latest from AUR
- **tmux**: Latest from Arch repos
- **Zsh**: Latest from Arch repos

### DevOps Tools
All DevOps tools are installed from official Arch/AUR repositories at their latest stable versions:
- **kubectl**: Latest stable
- **kubectx**: Latest stable
- **helm**: Latest stable
- **k9s**: Latest stable
- **terraform**: Latest stable
- **ansible**: Latest stable
- **aws-cli-v2**: Latest stable
- **google-cloud-cli**: Latest stable
- **azure-cli**: Latest stable

## Additional Resources

- [Omarchy Official Site](https://omarchy.com)
- [Omarchy Manual - Dotfiles](https://learn.omacom.io/2/the-omarchy-manual/65/dotfiles)
- [Hyprland Wiki](https://wiki.hyprland.org)
- [mise Documentation](https://mise.jdx.dev)
- [Ghostty Documentation](https://ghostty.org/docs)
- [TypeCraft Dotfiles](https://github.com/typecraft-dev/dotfiles)

## License

This is a personal configuration repository. Use at your own discretion.

## Contributing

This is a personal setup repository, but feel free to fork and adapt for your own use!
