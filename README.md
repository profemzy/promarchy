# Omarchy Supplement

Personal supplemental installation and configuration scripts for [Omarchy](https://omarchy.com) - a curated Arch Linux distribution with Hyprland.

## Overview

This repository contains automated setup scripts to extend Omarchy with additional tools, customized configurations, and development environments. **All customizations follow the [Omarchy configuration philosophy](https://learn.omacom.io/2/the-omarchy-manual/65/dotfiles)** of keeping user customizations in `~/.config/` while preserving core Omarchy files in `~/.local/share/omarchy/`.

This ensures all your customizations **persist through omarchy updates** without being overwritten.

## What's Included

### Core Tools
- **Zsh** - Z shell with modern features
- **mise** - Fast, polyglot version manager (replaces asdf)
- **Ghostty** - Modern, GPU-accelerated terminal emulator
- **tmux** - Terminal multiplexer with plugin manager (TPM)
- **stow** - Symlink farm manager for dotfiles

### Development Environments
- **Node.js** (v25.2.1) - JavaScript/TypeScript runtime (managed by mise)
- **Ruby** (v3.4.7) - Ruby programming language (managed by mise)
- **PostgreSQL** - Relational database with user setup

### DevOps Tools
**Kubernetes:**
- **kubectl** - Kubernetes command-line tool
- **kubectx** - Fast Kubernetes context switcher
- **kubens** - Kubernetes namespace switcher
- **helm** - Kubernetes package manager
- **k9s** - Kubernetes TUI (Terminal UI)
- **stern** - Multi-pod log tailing for Kubernetes

**GitOps & CD:**
- **argocd** - GitOps continuous delivery

**Infrastructure as Code:**
- **terraform** - Infrastructure as Code tool
- **ansible** - Configuration management and automation

**Cloud CLIs:**
- **aws-cli** - Amazon Web Services CLI
- **gcloud** - Google Cloud Platform CLI
- **azure-cli** - Microsoft Azure CLI

**Developer Tools:**
- **github-cli** (gh) - GitHub CLI for workflow automation

**Utilities:**
- **yq** - YAML/XML/TOML processor
- **httpie** - User-friendly HTTP client

### Customizations

**Dotfiles** - Pre-configured from [profemzy/dotfiles](https://github.com/profemzy/dotfiles)
- Neovim configuration
- Ghostty terminal config (integrated with omarchy theme system)
- tmux configuration
- Starship prompt
- Zsh configuration

**Hyprland Customizations** - All integrated into omarchy's recommended structure in `~/.config/hypr/`:

**Terminal & Browser:**
- `SUPER + RETURN` - Launch Ghostty terminal
- `SUPER + B` - Launch Chromium browser (0.8 scale)

**App Shortcuts:**
- `SUPER + D` - Discord web app
- `SUPER + G` - Notion

**Window Navigation (Vim-style):**
- `SUPER + h/j/k/l` - Focus left/down/up/right

**Monitor Management:**
- `SUPER + period` - Switch to next monitor
- `SUPER + comma` - Switch to previous monitor
- `SUPER + SHIFT + period` - Move window to next monitor
- `SUPER + SHIFT + comma` - Move window to previous monitor
- `SUPER + SHIFT + ALT + D` - Disable built-in display
- `SUPER + SHIFT + ALT + F` - Enable built-in display
- Automatic lid switch handling (laptops)

**Display Settings:**
- 2.0 monitor scaling for retina displays
- No window gaps
- DPMS power management

**Input Customizations:**
- Caps Lock mapped to Ctrl
- Faster keyboard repeat (rate: 50, delay: 220)
- Optimized touchpad scrolling

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
./install-nodejs.sh      # Node.js (via mise)
./install-ruby.sh        # Ruby (via mise)
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
./install-hyprland-overrides.sh  # Information about Hyprland customizations
```

All installation scripts are **idempotent** and can be run multiple times safely.

## Configuration Details

### Omarchy Configuration Philosophy

Omarchy separates user configurations from system files:
- **User configs**: `~/.config/` - Your customizations (safe to edit, persist through updates)
- **System files**: `~/.local/share/omarchy/` - Omarchy's defaults (don't edit directly)

**Always modify files in `~/.config/` to preserve your changes across Omarchy updates.**

### Hyprland Customizations

All Hyprland customizations are integrated directly into omarchy's recommended config structure:

**~/.config/hypr/bindings.conf** - Keybindings and app shortcuts
- Custom browser variable (`$browser = chromium --force-device-scale-factor=0.8`)
- Discord, Notion app shortcuts
- Vim-style window navigation (h/j/k/l)
- Monitor switching and window movement
- Lid switch handling for laptops

**~/.config/hypr/monitors.conf** - Monitor configuration
- 2.0 scaling for retina displays
- Default monitor settings

**~/.config/hypr/input.conf** - Keyboard and mouse settings
- Caps Lock remapped to Ctrl (`kb_options = ctrl:nocaps`)
- Keyboard repeat rate: 50, delay: 220
- Touchpad scroll factor: 0.4

**~/.config/hypr/looknfeel.conf** - Appearance and layout
- Window gaps: 0 (no gaps)
- DPMS power management enabled

This approach ensures **all customizations persist through omarchy updates** since they're in your user config directory, not in omarchy's system files.

### Ghostty Configuration

Located at `~/.config/ghostty/config` (symlinked from dotfiles):
- **Theme**: Automatically follows omarchy system theme
- **Font size**: 14pt
- **Background opacity**: 0.95
- **GTK titlebar**: Disabled

#### Omarchy Theme Integration

Ghostty is configured to automatically switch themes when you change your omarchy system theme:

- Theme colors are imported from `~/.config/omarchy/current/theme/ghostty.conf`
- When you switch themes using omarchy's theme switcher, Ghostty automatically updates
- The dotfiles maintain this integration and will not override omarchy's theme switching
- All available omarchy themes (Tokyo Night, Catppuccin, Gruvbox, etc.) are supported

To switch themes, use omarchy's built-in theme switcher - no manual Ghostty config editing required!

### Version Management with mise

mise is a fast, polyglot version manager (written in Rust) that replaces asdf. It manages different versions of programming languages and tools per-project or globally.

#### Configuration Files

mise uses two types of configuration:

**Global config** (`~/.config/mise/config.toml`):
```toml
[tools]
node = "25"
ruby = "3.4.7"
bun = "latest"
go = "latest"
```

**Project config** (`mise.toml` in project directory):
```toml
[tools]
node = "25"
```

Projects can override global settings by having their own `mise.toml` file.

#### Common Commands

**Install versions:**
```bash
mise install                 # Install all tools from config
mise install node@25         # Install specific version
mise install node@latest     # Install latest version
```

**Set versions:**
```bash
mise use -g node@25          # Set globally (~/.config/mise/config.toml)
mise use node@18             # Set for current project (creates mise.toml)
```

**View versions:**
```bash
mise current                 # Show active versions in current directory
mise ls                      # List all installed versions
mise ls node                 # List installed node versions
```

**Update tools:**
```bash
mise upgrade                 # Upgrade all tools to latest versions
mise upgrade node            # Upgrade only node
```

#### Per-Project Version Management

When you enter a directory with a `mise.toml` file, mise automatically switches to those versions:

```bash
cd ~/my-project              # mise detects mise.toml and switches versions
node --version               # Shows the project's node version
```

#### Quick Tips

- mise is **much faster** than asdf (written in Rust vs shell scripts)
- mise can read `.tool-versions` files (asdf format) for compatibility
- Changes take effect immediately - no need to restart your shell
- Global versions are overridden by project-specific versions
- Use `mise doctor` to check your setup

### Shell Aliases

The dotfiles include convenient aliases for common DevOps commands:

```bash
k             # kubectl
dc            # docker compose
tm            # new_tmux (smart tmux session manager)
```

**Usage examples:**
```bash
k get pods                    # Instead of: kubectl get pods
k apply -f deployment.yaml    # Instead of: kubectl apply -f deployment.yaml
dc up -d                      # Instead of: docker compose up -d
dc down                       # Instead of: docker compose down
tm                            # Launch tmux session picker
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

**GitHub CLI:**
```bash
gh auth login
# Follow the interactive setup to authenticate with GitHub
gh repo list     # List your repositories
gh pr list       # List pull requests
```

**Kubernetes:**
```bash
kubectl config view              # View current config
kubectl config get-contexts      # List available contexts
kubectx                          # Switch contexts easily
kubens                           # Switch namespaces easily
k9s                              # Launch Kubernetes TUI
stern <pod-name>                 # Tail logs from multiple pods
```

**ArgoCD:**
```bash
argocd login <server>            # Login to ArgoCD server
argocd app list                  # List applications
argocd app sync <app-name>       # Sync application
```

**Terraform:**
```bash
terraform init    # Initialize working directory
terraform plan    # Preview changes
terraform apply   # Apply changes
```

**Utilities:**
```bash
# YAML processing
yq '.spec.replicas' deployment.yaml

# HTTP requests
http GET https://api.github.com/users/profemzy
```

## Customizing Configurations

### Modify Hyprland Settings

Edit the appropriate config file in `~/.config/hypr/`:

```bash
# Keybindings and app shortcuts
nano ~/.config/hypr/bindings.conf

# Monitor settings
nano ~/.config/hypr/monitors.conf

# Input devices (keyboard, mouse, touchpad)
nano ~/.config/hypr/input.conf

# Look and feel (gaps, layout, DPMS)
nano ~/.config/hypr/looknfeel.conf

# Environment variables
nano ~/.config/hypr/envs.conf
```

Then reload Hyprland to apply changes:
```bash
hyprctl reload
```

### Modify Dotfiles

Dotfiles are managed via stow. To customize:

1. Navigate to dotfiles:
   ```bash
   cd ~/dotfiles
   ```

2. Edit the desired configuration in the appropriate directory:
   - `ghostty/.config/ghostty/config` - Terminal config
   - `nvim/.config/nvim/` - Neovim config
   - `tmux/.config/tmux/` - tmux config
   - `starship/.config/starship.toml` - Prompt config
   - `zshrc/.zshrc` - Zsh config

3. Changes are immediately applied (symlinks)

### Modify Shell Configuration

Personal shell customizations should go in `~/.bashrc` or `~/.zshrc`, which won't be overwritten during Omarchy updates.

## Troubleshooting

### Keybinding Conflicts

**Issue:** Some custom keybindings conflict with omarchy defaults.

**Solution:** The supplement has resolved common conflicts:
- `SUPER + SHIFT + D` (Docker) and `SUPER + SHIFT + F` (File Manager) remain unchanged
- Monitor enable/disable moved to `SUPER + SHIFT + ALT + D/F` to avoid conflicts

To add your own keybindings, edit `~/.config/hypr/bindings.conf` and use `unbind` before creating new bindings:
```bash
unbind = SUPER, X
bindd = SUPER, X, My App, exec, my-command
```

### Terminal Theme Not Switching

**Issue:** Ghostty doesn't change theme when switching omarchy themes.

**Solution:** The Ghostty configuration should import from omarchy's theme system. Check that `~/.config/ghostty/config` contains:
```
config-file = ~/.config/omarchy/current/theme/ghostty.conf
```

If it doesn't, edit `~/dotfiles/ghostty/.config/ghostty/config` and add the line above at the top of the file. Changes are immediate since the config is symlinked.

**Verify the integration:**
```bash
# Check if omarchy theme file exists
cat ~/.config/omarchy/current/theme/ghostty.conf

# Should show something like:
# theme = TokyoNight
```

### mise: "missing: ruby@3.4.7" or "missing: nodejs@..."

**Solution:** Install the missing tool version:
```bash
mise install ruby@3.4.7
# or
mise install  # Install all from config
```

**Check your configuration:**
```bash
mise doctor  # Verify mise setup
mise current # Show what versions are expected
mise ls      # Show what versions are installed
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

### Hyprland Settings Not Applying

If your Hyprland customizations aren't working after an omarchy update:

1. Verify settings are in `~/.config/hypr/` files (not in `~/.local/share/omarchy/`)
2. Reload Hyprland: `hyprctl reload`
3. Check for syntax errors: Review the specific config file for typos
4. Test incrementally: Comment out sections to isolate issues

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
├── install-hyprland-overrides.sh  # Info about Hyprland customizations
├── set-shell.sh                # Set Zsh as default shell
├── hyprland-overrides.conf.archived  # Archived old config (reference only)
└── README.md                   # This file
```

## Hyprland Configuration Location

**Your Hyprland customizations are in:**
- `~/.config/hypr/bindings.conf` - Keybindings and shortcuts
- `~/.config/hypr/monitors.conf` - Monitor configuration
- `~/.config/hypr/input.conf` - Input device settings
- `~/.config/hypr/looknfeel.conf` - Appearance and layout
- `~/.config/hypr/envs.conf` - Environment variables

These files are **safe to edit** and will **persist through omarchy updates**.

## Version Information

### Development Tools
- **Node.js**: 25 (managed by mise, configured in ~/.config/mise/config.toml)
- **Ruby**: 3.4.7 (managed by mise, configured in ~/.config/mise/config.toml)
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

## License

This is a personal configuration repository. Use at your own discretion.

## Contributing

This is a personal setup repository, but feel free to fork and adapt for your own use!
