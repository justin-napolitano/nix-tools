---
slug: github-nix-tools
title: Declarative Development Environment with Nix Flakes and Home Manager
repo: justin-napolitano/nix-tools
githubUrl: https://github.com/justin-napolitano/nix-tools
generatedAt: '2025-11-23T09:20:55.183713Z'
source: github-auto
summary: >-
  Reference implementation of a reproducible workstation setup using Nix flakes, Home Manager, and
  modern development tools on Linux.
tags:
  - nix
  - home-manager
  - nix-flakes
  - linux
  - dev-environment
  - dotfiles
seoPrimaryKeyword: nix flakes
seoSecondaryKeywords:
  - home manager
  - declarative environment
  - development workstation
  - linux
seoOptimized: true
topicFamily: devtools
topicFamilyConfidence: 0.95
topicFamilyNotes: >-
  The post is about declarative development environment setup using Nix flakes and Home Manager,
  focusing on reproducible workstation setup, shell and editor configuration, and development
  tooling, which aligns closely with the 'Devtools' family description and example slugs.
---

# Nix Workstation: A Declarative Development Environment

This project establishes a reproducible and declarative development environment using Nix flakes and Home Manager. It addresses the common problem of environment drift and complexity in managing development tools, shells, and editors across machines.

## Motivation

Developers frequently face inconsistencies in their local environments due to manual configuration, version mismatches, and ad hoc installations. This leads to productivity loss and bugs that are hard to reproduce. The approach here leverages Nix's declarative package management and Home Manager's user environment configuration to ensure that the entire workstation setup is reproducible and version controlled.

## Problem Statement

Maintaining a consistent development environment that includes shell configurations, language runtimes, editor plugins, and CLI tools is challenging. Manual setup is error-prone and not easily portable. Traditional dotfiles repositories lack strong guarantees about dependencies and versions.

## Implementation Details

- **Nix flakes** provide a reproducible and composable way to define dependencies and configurations. The `flake.nix` file pins package versions and defines inputs such as nixpkgs and Home Manager.

- **Home Manager** is used to declaratively configure user-level settings including Zsh with Oh-My-Zsh and Powerlevel10k, shell plugins (autosuggestions, syntax highlighting), and Neovim with a curated set of plugins and language servers.

- The environment includes modern development tools such as Node.js 22, Python 3.12, Terraform, Docker, AWS CLI, and utilities like Git, Bat, Ripgrep, and Tmux.

- A custom alias `chat` is provided to invoke the ChatGPT CLI via `npx`, integrating AI assistance into the shell.

- The setup integrates Direnv with flakes and Home Manager, enabling environment variable management tied to project directories.

- Scripts like `install.sh`, `nuke.sh`, and `update_home_manager` automate setup, teardown, and maintenance workflows.

- The Powerlevel10k prompt is configured to launch an initial setup wizard on first shell start, improving user onboarding.

- OpenAI API key management is handled outside the repository to keep secrets secure.

## Usage

The user installs Nix with flakes enabled, clones the repository, and activates the Home Manager configuration using the provided `nix run` command. Starting a new shell applies the environment settings.

A pinned development shell can be entered with `nix develop`, which provides language runtimes and tooling isolated from the host system.

## Practical Considerations

- The declarative approach simplifies onboarding new machines and reduces configuration drift.

- Using Nix flakes ensures reproducible builds and easy updates via `nix flake update`.

- The modular structure (dotfiles, home configs, scripts) allows for easy customization and extension.

- The project assumes a Linux environment; cross-platform support is a potential future enhancement.

## Conclusion

This repository serves as a reference implementation for managing a complex development environment declaratively. It combines Nix flakes and Home Manager to provide a robust, reproducible, and maintainable workstation setup that can be extended and adapted as needed.

Future work includes expanding platform support, enriching tooling configurations, and improving automation around secrets management and onboarding.


