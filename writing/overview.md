---
slug: github-nix-tools-writing-overview
id: github-nix-tools-writing-overview
title: 'Nix Tools: My Declarative Dev Environment'
repo: justin-napolitano/nix-tools
githubUrl: https://github.com/justin-napolitano/nix-tools
generatedAt: '2025-11-24T17:44:29.195Z'
source: github-auto
summary: >-
  I’m excited to share my GitHub repository,
  [nix-tools](https://github.com/justin-napolitano/nix-tools). It’s a project
  that focuses on creating a fully reproducible development environment using
  Nix flakes and Home Manager. Essentially, it’s my take on a consistent,
  declarative setup for all my essential tooling.
tags: []
seoPrimaryKeyword: ''
seoSecondaryKeywords: []
seoOptimized: false
topicFamily: null
topicFamilyConfidence: null
kind: writing
entryLayout: writing
showInProjects: false
showInNotes: false
showInWriting: true
showInLogs: false
---

I’m excited to share my GitHub repository, [nix-tools](https://github.com/justin-napolitano/nix-tools). It’s a project that focuses on creating a fully reproducible development environment using Nix flakes and Home Manager. Essentially, it’s my take on a consistent, declarative setup for all my essential tooling.

## What is It?

The core purpose of this repo is pretty straightforward: I wanted a development workstation that I could spin up anywhere, without worrying about ticking off all the dependencies. With Nix, that’s possible. The environment I’ve set up is clean, predictable, and allows me to switch between projects smoothly. 

## Why It Exists

I often found myself dealing with setup headaches for different systems. Each time I moved to a new machine or reset my environment, it felt like I was back to square one. I wanted to eliminate the frustrating guesswork with “what tools do I need, and will they work together?” The solution? An environment that’s entirely declarative, meaning everything is defined explicitly in configuration files. 

In addition, being able to easily share this configuration with other developers is a huge plus. Now, if someone wants to replicate my setup, they can do so with minimal effort.

## Key Design Decisions

1. **Reproducibility**: Using Nix with flakes ensures that my entire environment can be replicated on any machine with just a few commands. No package conflicts or hidden dependencies.

2. **Declarative Configuration**: Everything is defined in configuration files — no manual setup required. I can treat my dev environment like code. Change it in the repo and boom, everyone can benefit.

3. **Focus on Essential Tools**: Instead of bloating the setup with unnecessary software, I honed in on what I use daily. This keeps the environment lean and efficient.

4. **Neovim as My Editor**: I decided to stick with Neovim for maximum flexibility. It’s super customizable, and I leverage Lua plugins for enhanced functionality.

## Tech Stack

The tech stack for this project is pretty straightforward:

- **Nix**: The backbone of my environment, allowing me to manage dependencies and ensure reproducibility.
- **Home Manager**: This helps me manage my user-level configurations declaratively.
- **Zsh**: I chose Zsh for its awesome features. Plus, Oh-My-Zsh and Powerlevel10k give me a nice prompt.
- **Neovim**: Configured with lazy.nvim, Treesitter, and a bunch of language servers.

## Getting Started

So, how can you get this up and running? Here’s a quick rundown:

### Prerequisites

First, you’ll need to install Nix with flakes support:

```bash
sh <(curl -L https://nixos.org/nix/install) --no-daemon
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### Clone the Repository

Next, grab the repo:

```bash
git clone https://github.com/justin-napolitano/nix-tools.git
cd nix-tools
```

### Activate Configuration

You’ll also need to activate the Home Manager configuration:

```bash
nix run home-manager/master -- switch --flake .#cobra@linux
```

### Start Your Shell

Finally, start your shell:

```bash
exec zsh
```

The Powerlevel10k setup wizard will guide you through the initial configuration!

## Project Structure

Here’s a quick look at how the project is structured:

- `flake.nix` and `flake.lock`: The main configuration files for managing packages.
- `home/`: Contains user configurations for Home Manager.
- `dotfiles/`: All my user dotfiles managed in a declarative way.
- `scripts/`: Various utility scripts for managing the environment.
- `install.sh`: A bootstrap script to set everything up.
- `README.md`: You’re looking at it!
- `index.md`: Offers extended documentation for deeper insights.
- `Makefile`: Contains build and maintenance commands.

## Future Work / Roadmap

I’ve got some ideas on what to improve next:

- **Multi-Platform Support**: I’d like to extend this setup for non-Linux systems.
- **More Language Support**: Adding additional language servers and tooling configurations to cater to more use cases.
- **Automate OpenAI API Integration**: Streamline the setup of OpenAI keys.
- **Enhanced Neovim Customizations**: More plugins and tweaks to improve the editing experience.
- **Better Onboarding**: I want to further simplify the documentation and user experience.

## Stay Updated

I plan to keep this project evolving, and I share updates across social platforms like Mastodon, Bluesky, and Twitter/X. So, if you’re interested, give me a follow!

Overall, I hope this repo helps simplify your development setup as much as it has for me. If you've got thoughts, issues, or contributions, feel free to open a GitHub issue or pull request. Enjoy your coding!
