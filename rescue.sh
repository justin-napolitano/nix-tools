# 1) Make timestamped backups
cp -a ~/.zprofile ~/.zprofile.bak.$(date +%Y%m%d%H%M%S) 2>/dev/null || true
cp -a ~/.zshrc    ~/.zshrc.bak.$(date +%Y%m%d%H%M%S)    2>/dev/null || true
cp -a ~/.profile  ~/.profile.bak.$(date +%Y%m%d%H%M%S)  2>/dev/null || true

# 2) Ensure Nix is sourced for login shells (zsh reads .zprofile)
grep -Fqx 'if [ -r "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi' ~/.zprofile \
  || echo 'if [ -r "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi' >> ~/.zprofile

# 3) Also source for interactive shells (covers odd SSH setups)
grep -Fqx 'if [ -r "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi' ~/.zshrc \
  || echo 'if [ -r "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi' >> ~/.zshrc

# 4) Belt-and-suspenders for shells that read ~/.profile
grep -Fqx 'if [ -r "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi' ~/.profile \
  || echo 'if [ -r "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then . "$HOME/.nix-profile/etc/profile.d/nix.sh"; fi' >> ~/.profile

# 5) Keep flakes on for single-user installs
mkdir -p ~/.config/nix
grep -q 'experimental-features.*flakes' ~/.config/nix/nix.conf 2>/dev/null \
  || echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf

# 6) Reload as a *login* shell
exec zsh -l

