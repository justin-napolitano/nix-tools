#!/usr/bin/env bash

set -euo pipefail

ts=$(date +%Y%m%d%H%M%S)

echo "== Back up dotfiles =="
for f in ~/.profile ~/.zprofile ~/.zshrc ~/.bashrc ~/.bash_profile ~/.pam_environment; do
  [ -f "$f" ] && cp -a "$f" "${f}.bak.$ts" || true
done

echo "== Save any nix-env user packages list (if any) =="
if command -v nix-env >/dev/null 2>&1; then
  nix-env -q > "$HOME/nix-env-list.$ts.txt" || true
  echo "Saved user package list to ~/nix-env-list.$ts.txt"
fi

echo "== Remove Nix profile directories (user) =="
rm -rf "$HOME/.nix-profile" "$HOME/.nix-defexpr" "$HOME/.nix-channels" 2>/dev/null || true

echo "== Remove Nix lines from shell profiles (non-destructive, we have backups) =="
for f in ~/.profile ~/.zprofile ~/.zshrc ~/.bashrc ~/.bash_profile; do
  [ -f "$f" ] || continue
  sed -i '/nix-daemon\.sh/d' "$f" || true
  sed -i '/\.nix-profile\/etc\/profile\.d\/nix\.sh/d' "$f" || true
  sed -i '/\/etc\/profile\.d\/nix\.sh/d' "$f" || true
done

echo "== Try system uninstall script if present (multi-user installs) =="
if [ -x /nix/nix-installer ]; then
  sudo /nix/nix-installer uninstall || true
fi

echo "== Remove system bits if they exist (may prompt for sudo) =="
# Only do this if you're sure this host isn't using Nix for other users:
if [ -d /nix ]; then
  sudo mv /nix "/nix.backup.$ts" || true
  echo "Moved /nix to /nix.backup.$ts (you can delete later)"
fi

sudo rm -f /etc/profile.d/nix.sh /etc/zsh/zprofile.d/nix.sh 2>/dev/null || true
sudo rm -f /etc/systemd/system/nix-daemon.service 2>/dev/null || true
sudo systemctl daemon-reload || true

echo "== Clean PATH artifacts in current shell =="
hash -r || true

echo "Uninstall cleanup complete."

