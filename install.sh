#!/usr/bin/env bash

# Install multi-user Nix (daemon)
sh <(curl -L https://nixos.org/nix/install) --daemon

# Ensure flakes + nix-command
sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee -a /etc/nix/nix.conf

# Start a *login* shell so /etc/profile.d/nix.sh is applied
exec zsh -l

# Sanity checks
nix --version
print -l $path | grep -nE '^(/nix|.*/\.nix-profile/)'

