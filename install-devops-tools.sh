#!/bin/bash

set -e

echo "Installing DevOps tools..."
echo ""

# Function to check if a command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Function to install package if not already installed
install_if_missing() {
    local cmd=$1
    local package=$2

    if command_exists "$cmd"; then
        echo "✓ $cmd is already installed"
        return 0
    fi

    echo "Installing $package..."
    yay -S --noconfirm --needed "$package"
    echo "✓ $package installed successfully"
}

# Kubernetes tools
echo "[1/15] kubectl - Kubernetes CLI"
install_if_missing kubectl kubectl

echo ""
echo "[2/15] kubectx - Kubernetes context switcher"
install_if_missing kubectx kubectx

echo ""
echo "[3/15] kubens - Kubernetes namespace switcher"
if command_exists kubens; then
    echo "✓ kubens is already installed"
else
    echo "✓ kubens is included with kubectx package"
fi

echo ""
echo "[4/15] helm - Kubernetes package manager"
install_if_missing helm helm

echo ""
echo "[5/15] k9s - Kubernetes TUI"
install_if_missing k9s k9s

echo ""
echo "[6/15] stern - Multi-pod log tailing for Kubernetes"
install_if_missing stern stern

# GitOps & CD
echo ""
echo "[7/15] argocd - GitOps continuous delivery"
install_if_missing argocd argocd

# Infrastructure as Code
echo ""
echo "[8/15] terraform - Infrastructure as Code"
install_if_missing terraform terraform

echo ""
echo "[9/15] ansible - Configuration management"
install_if_missing ansible ansible

# Cloud CLIs
echo ""
echo "[10/15] aws-cli - AWS Command Line Interface"
if command_exists aws; then
    echo "✓ aws-cli is already installed"
else
    echo "Installing aws-cli-v2..."
    yay -S --noconfirm --needed aws-cli-v2
    echo "✓ aws-cli-v2 installed successfully"
fi

echo ""
echo "[11/15] gcloud - Google Cloud CLI"
if command_exists gcloud; then
    echo "✓ gcloud is already installed"
else
    echo "Installing google-cloud-cli..."
    yay -S --noconfirm --needed google-cloud-cli
    echo "✓ google-cloud-cli installed successfully"
fi

echo ""
echo "[12/15] az - Azure CLI"
if command_exists az; then
    echo "✓ azure-cli is already installed"
else
    echo "Installing azure-cli..."
    yay -S --noconfirm --needed azure-cli
    echo "✓ azure-cli installed successfully"
fi

echo ""
echo "[13/15] gh - GitHub CLI"
install_if_missing gh github-cli

# Utilities
echo ""
echo "[14/15] yq - YAML/XML/TOML processor"
install_if_missing yq yq

echo ""
echo "[15/15] httpie - User-friendly HTTP client"
install_if_missing http httpie

echo ""
echo "==================================="
echo "DevOps tools installation complete!"
echo "==================================="
echo ""
echo "Installed tools:"
echo "  - kubectl $(kubectl version --client --short 2>/dev/null || echo '')"
echo "  - kubectx $(kubectx --version 2>/dev/null || echo '')"
echo "  - kubens (included with kubectx)"
echo "  - helm $(helm version --short 2>/dev/null || echo '')"
echo "  - k9s $(k9s version --short 2>/dev/null || echo '')"
echo "  - stern $(stern --version 2>/dev/null || echo '')"
echo "  - argocd $(argocd version --client --short 2>/dev/null || echo '')"
echo "  - terraform $(terraform version -json 2>/dev/null | grep -o '"version":"[^"]*"' | cut -d'"' -f4 || echo '')"
echo "  - ansible $(ansible --version 2>/dev/null | head -1 || echo '')"
echo "  - aws $(aws --version 2>/dev/null || echo '')"
echo "  - gcloud $(gcloud version 2>/dev/null | head -1 || echo '')"
echo "  - az $(az version 2>/dev/null | grep -o '"azure-cli": "[^"]*"' | cut -d'"' -f4 || echo '')"
echo "  - gh $(gh --version 2>/dev/null | head -1 || echo '')"
echo "  - yq $(yq --version 2>/dev/null || echo '')"
echo "  - httpie $(http --version 2>/dev/null || echo '')"
echo ""
echo "Setting up kubectl autocomplete..."
if ! grep -q "kubectl completion zsh" ~/.zshrc 2>/dev/null; then
    echo "" >> ~/.zshrc
    echo "# kubectl autocomplete" >> ~/.zshrc
    echo "source <(kubectl completion zsh)" >> ~/.zshrc
    echo "✓ kubectl autocomplete added to ~/.zshrc"
else
    echo "✓ kubectl autocomplete already configured"
fi

echo ""
echo "Next steps:"
echo "  - Restart your shell or run: source ~/.zshrc"
echo "  - Configure AWS: aws configure"
echo "  - Configure GCloud: gcloud init"
echo "  - Configure Azure: az login"
echo "  - Configure GitHub: gh auth login"
echo "  - Configure kubectl: kubectl config view"
echo "  - Configure ArgoCD: argocd login <server>"
