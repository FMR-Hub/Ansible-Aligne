#!/usr/bin/env bash

set -euo pipefail

INSTALL_DIR="$HOME/bin"
SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/functions"
CONFIG_FILE="$HOME/.ansiblealigne.conf"

echo "### Starting Ansible-Aligne installation"
echo "Target install directory: $INSTALL_DIR"
echo "Source functions directory: $SOURCE_DIR"
if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Functions directory '$SOURCE_DIR' not found."
  exit 1
fi
mkdir -p "$INSTALL_DIR"
echo "[OK] Created or confirmed target directory: $INSTALL_DIR"
cp "$SOURCE_DIR/"* "$INSTALL_DIR/"
echo "[OK] Copied scripts to $INSTALL_DIR"

chmod +x "$INSTALL_DIR/"*
echo "[OK] Marked scripts as executable"

if ! echo "$PATH" | grep -q "$HOME/bin"; then
  echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.bashrc"
  echo "[INFO] Added \$HOME/bin to PATH via .bashrc"
  echo "Please run 'source ~/.bashrc' or restart your terminal."
else
  echo "[OK] \$HOME/bin is already in PATH"
fi

if [ ! -f "$CONFIG_FILE" ]; then
  echo "[INFO] No configuration file found. Running init script..."
  "$INSTALL_DIR/ansiblealigne.init"
else
  echo "[OK] Existing config found at $CONFIG_FILE"
fi

echo "### Ansible-Aligne installation complete"
