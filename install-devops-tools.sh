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
echo "[1/9] kubectl - Kubernetes CLI"
install_if_missing kubectl kubectl

echo ""
echo "[2/9] kubectx - Kubernetes context switcher"
install_if_missing kubectx kubectx

echo ""
echo "[3/9] helm - Kubernetes package manager"
install_if_missing helm helm

echo ""
echo "[4/9] k9s - Kubernetes TUI"
install_if_missing k9s k9s

# Infrastructure as Code
echo ""
echo "[5/9] terraform - Infrastructure as Code"
install_if_missing terraform terraform

echo ""
echo "[6/9] ansible - Configuration management"
install_if_missing ansible ansible

# Cloud CLIs
echo ""
echo "[7/9] aws-cli - AWS Command Line Interface"
if command_exists aws; then
    echo "✓ aws-cli is already installed"
else
    echo "Installing aws-cli-v2..."
    yay -S --noconfirm --needed aws-cli-v2
    echo "✓ aws-cli-v2 installed successfully"
fi

echo ""
echo "[8/9] gcloud - Google Cloud CLI"
if command_exists gcloud; then
    echo "✓ gcloud is already installed"
else
    echo "Installing google-cloud-cli..."
    yay -S --noconfirm --needed google-cloud-cli
    echo "✓ google-cloud-cli installed successfully"
fi

echo ""
echo "[9/9] az - Azure CLI"
if command_exists az; then
    echo "✓ azure-cli is already installed"
else
    echo "Installing azure-cli..."
    yay -S --noconfirm --needed azure-cli
    echo "✓ azure-cli installed successfully"
fi

echo ""
echo "==================================="
echo "DevOps tools installation complete!"
echo "==================================="
echo ""
echo "Installed tools:"
echo "  - kubectl $(kubectl version --client --short 2>/dev/null || echo '')"
echo "  - kubectx $(kubectx --version 2>/dev/null || echo '')"
echo "  - helm $(helm version --short 2>/dev/null || echo '')"
echo "  - k9s $(k9s version --short 2>/dev/null || echo '')"
echo "  - terraform $(terraform version -json 2>/dev/null | grep -o '"version":"[^"]*"' | cut -d'"' -f4 || echo '')"
echo "  - ansible $(ansible --version 2>/dev/null | head -1 || echo '')"
echo "  - aws $(aws --version 2>/dev/null || echo '')"
echo "  - gcloud $(gcloud version 2>/dev/null | head -1 || echo '')"
echo "  - az $(az version 2>/dev/null | grep -o '"azure-cli": "[^"]*"' | cut -d'"' -f4 || echo '')"
echo ""
echo "Next steps:"
echo "  - Configure AWS: aws configure"
echo "  - Configure GCloud: gcloud init"
echo "  - Configure Azure: az login"
echo "  - Configure kubectl: kubectl config view"
