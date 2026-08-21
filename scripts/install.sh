#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
qs_dir="${QS_CAELESTIA_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/quickshell/caelestia}"

if ! command -v obsidian >/dev/null 2>&1; then
    echo "Error: Obsidian CLI was not found in PATH." >&2
    echo "Install/enable the Obsidian CLI first, then run this installer again." >&2
    exit 1
fi

mkdir -p "$qs_dir" "$HOME/.local/bin"

# This module follows the installation model of caelestia-ai: its
# quickshell files are copied into the active Caelestia configuration.
cp -r "$repo_dir/quickshell/"* "$qs_dir/"

if [[ -f "$repo_dir/bin/caelestia-blob" ]]; then
    install -m 755 "$repo_dir/bin/caelestia-blob" "$HOME/.local/bin/caelestia-blob"
fi

echo "Installed Caelestia Note module files into: $qs_dir"
echo "Obsidian CLI: $(command -v obsidian)"
echo
echo "Restart Quickshell to load the module:"
echo "  pkill quickshell"
echo "  quickshell -c caelestia &"
echo
echo "If you use a custom Caelestia path, set QS_CAELESTIA_DIR before running this script."