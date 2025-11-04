# --- QUICK NIX/ZSH RESCUE ---

set -euo pipefail

echo "== shell =="
echo "$SHELL"
echo "== whoami =="
whoami
echo "== PATH contains nix? =="
echo "$PATH" | tr ':' '\n' | grep -n '^/nix' || true

echo "== nix binaries =="
command -v nix || echo "nix NOT found in PATH"
command -v nix-shell || true
command -v nix-env || true

echo "== check daemon profile scripts =="
ls -l /nix/var/nix/profiles/default/etc/profile.d/ 2>/dev/null || true
ls -l "$HOME/.nix-profile/etc/profile.d/" 2>/dev/null || true

# Source nix into THIS session if available (multi-user first, then single-user)
if [ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
elif [ -r "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  # shellcheck disable=SC1091
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

echo "== nix after sourcing =="
command -v nix || echo "nix still NOT found in PATH"

# Helper: add a line to a file if it's not already present (creates .bak once)
add_line_once() {
  local file="$1"
  local line="$2"

  [ -f "$file" ] || touch "$file"
  if ! grep -Fqx "$line" "$file"; then
    cp -a "$file" "${file}.bak.$(date +%Y%m%d%H%M%S)"
    printf '%s\n' "$line" >> "$file"
    echo "Added to $file: $line"
  else
    echo "Already present in $file: $line"
  fi
}

# Ensure zsh login + interactive sessions load Nix
NIX_MULTI_LINE='if [ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh; fi'
NIX_SINGLE_LINE='if [ -r "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi'

# Use multi-user first if present, else single-user
if [ -r /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
  add_line_once "$HOME/.zprofile" "$NIX_MULTI_LINE"
  add_line_once "$HOME/.zshrc"   "$NIX_MULTI_LINE"
else
  add_line_once "$HOME/.zprofile" "$NIX_SINGLE_LINE"
  add_line_once "$HOME/.zshrc"    "$NIX_SINGLE_LINE"
fi

# Optional but handy: direnv hook if installed
if command -v direnv >/dev/null 2>&1; then
  DIRENV_LINE='eval "$(direnv hook zsh)"'
  add_line_once "$HOME/.zshrc" "$DIRENV_LINE"
fi

# Ensure experimental features (flakes/nix-command) if you use flakes
NIX_CONF_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nix"
mkdir -p "$NIX_CONF_DIR"
if [ -f "$NIX_CONF_DIR/nix.conf" ]; then
  cp -a "$NIX_CONF_DIR/nix.conf" "$NIX_CONF_DIR/nix.conf.bak.$(date +%Y%m%d%H%M%S)"
fi
touch "$NIX_CONF_DIR/nix.conf"
if ! grep -Eq '^\s*experimental-features\s*=\s*.*(nix-command|flakes)' "$NIX_CONF_DIR/nix.conf"; then
  echo "experimental-features = nix-command flakes" >> "$NIX_CONF_DIR/nix.conf"
  echo "Enabled flakes/command in $NIX_CONF_DIR/nix.conf"
fi

# Try to (re)start nix-daemon on multi-user installs (Ubuntu server usually uses this)
if command -v systemctl >/dev/null 2>&1 && [ -e /etc/systemd/system/nix-daemon.service ] || systemctl list-unit-files | grep -q '^nix-daemon\.service'; then
  echo "== nix-daemon status (before) =="
  systemctl status nix-daemon --no-pager || true
  sudo systemctl enable --now nix-daemon || true
  echo "== nix-daemon status (after) =="
  systemctl status nix-daemon --no-pager || true
fi

echo "== test nix eval =="
nix --version || true
nix eval --impure --expr '1+1' || true

echo
echo "✅ Done. Start a fresh login shell:"
echo "   exec zsh -l"

