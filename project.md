---
slug: github-nix-tools
id: github-nix-tools
title: Nix Workstation — Cobra’s Declarative Dev Environment
repo: justin-napolitano/nix-tools
githubUrl: https://github.com/justin-napolitano/nix-tools
generatedAt: '2025-11-24T21:35:44.486Z'
source: github-auto
summary: >-
  A fully reproducible development workstation built with Nix flakes and Home
  Manager. This setup provides a consistent, declarative environment for shell,
  editor, and essential development tools.
tags: []
seoPrimaryKeyword: ''
seoSecondaryKeywords: []
seoOptimized: false
topicFamily: null
topicFamilyConfidence: null
kind: project
entryLayout: project
showInProjects: true
showInNotes: false
showInWriting: false
showInLogs: false
---

A fully reproducible development workstation built with Nix flakes and Home Manager. This setup provides a consistent, declarative environment for shell, editor, and essential development tools.

---

## Features

- Zsh with Oh-My-Zsh and Powerlevel10k prompt
- Autosuggestions and syntax highlighting for shell
- Neovim configured with lazy.nvim, Treesitter, and multiple language servers
- Common development utilities: Git, Bat, Eza, Fd, Ripgrep, Fzf, Tmux, Lazygit
- Node.js 22 and Python 3.12 environments
- Prettier, Terraform, Docker, AWS CLI
- ChatGPT CLI alias (`chat`) using `npx`
- Integration of Direnv with Nix flakes and Home Manager

---

## Tech Stack

- [Nix](https://nixos.org/) with flakes for reproducible package management
- [Home Manager](https://nix-community.github.io/home-manager/) for declarative user environment management
- Shell scripting (Zsh)
- Neovim configured with Lua plugins

---

## Getting Started

### Prerequisites

Install Nix with flakes support:

```bash
sh <(curl -L https://nixos.org/nix/install) --no-daemon
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### Clone the repository

```bash
git clone https://github.com/justin-napolitano/nix-tools.git
cd nix-tools
```

### Activate Home Manager configuration

```bash
nix run home-manager/master -- switch --flake .#cobra@linux
```

### Start your new shell

```bash
exec zsh
```

The Powerlevel10k prompt will launch its initial setup wizard.

### Development Shell

To enter the pinned development environment:

```bash
nix develop
```

This shell includes Node.js, npm, pip, language servers (TypeScript, Python, Bash, Lua, YAML), Terraform, kubectl, AWS CLI, and configured aliases.

Exit with:

```bash
exit
```

---

## Project Structure

- `flake.nix` and `flake.lock`: Nix flake configuration and lock file
- `home/`: Home Manager user configurations
- `dotfiles/`: User dotfiles managed declaratively
- `scripts/`: Utility scripts for installation, updates, and maintenance
- `install.sh`: Script to bootstrap the environment
- `README.MD`: This documentation
- `index.md`: Blog post and extended documentation
- `Makefile`: Build and maintenance commands

---

## Future Work / Roadmap

- Expand support for additional platforms beyond Linux
- Add more language servers and tooling configurations
- Automate OpenAI API key setup and integration
- Enhance Neovim setup with more plugins and customizations
- Improve documentation and onboarding experience

---

For issues and contributions, please open a GitHub issue or pull request on the repository.

---

_Note: Remember to keep your OpenAI API key private and do not commit it to version control._

---

## OpenAI API Key Setup

Create a private key file:

```bash
echo 'export OPENAI_API_KEY="sk-...your-key..."' > ~/.openai_api_key
echo 'export TOKEN="$OPENAI_API_KEY"' >> ~/.openai_api_key
chmod 600 ~/.openai_api_key
```

Reload your shell:

```bash
exec zsh
```

Test ChatGPT CLI:

```bash
chat "Write a Nix expression that prints hello world"
```

