---
slug: github-nix-tools-note-technical-overview
id: github-nix-tools-note-technical-overview
title: Nix Tools Overview
repo: justin-napolitano/nix-tools
githubUrl: https://github.com/justin-napolitano/nix-tools
generatedAt: '2025-11-24T18:42:03.513Z'
source: github-auto
summary: >-
  This repo sets up a reproducible development workstation using Nix flakes and
  Home Manager. It gives you a declarative environment with a ready-to-go shell,
  editor, and essential tools.
tags: []
seoPrimaryKeyword: ''
seoSecondaryKeywords: []
seoOptimized: false
topicFamily: null
topicFamilyConfidence: null
kind: note
entryLayout: note
showInProjects: false
showInNotes: true
showInWriting: false
showInLogs: false
---

This repo sets up a reproducible development workstation using Nix flakes and Home Manager. It gives you a declarative environment with a ready-to-go shell, editor, and essential tools.

## Key Features

- Zsh with Oh-My-Zsh and Powerlevel10k
- Configured Neovim with lazy.nvim and multiple language servers
- Utility tools like Git, Bat, and Tmux
- Node.js and Python environments
- Integrated ChatGPT CLI alias (`chat`)

## Getting Started

1. **Install Nix** with flakes:
   ```bash
   sh <(curl -L https://nixos.org/nix/install) --no-daemon
   mkdir -p ~/.config/nix
   echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
   ```

2. **Clone the repo**:
   ```bash
   git clone https://github.com/justin-napolitano/nix-tools.git
   cd nix-tools
   ```

3. **Activate Home Manager**:
   ```bash
   nix run home-manager/master -- switch --flake .#cobra@linux
   ```

4. **Start Zsh**:
   ```bash
   exec zsh
   ```

For the development shell, run:
```bash
nix develop
```

**Important**: Keep your OpenAI API key private.
