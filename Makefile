SHELL := /bin/bash
.PHONY: bootstrap nix-install flakes direnv envrc write-flake write-home-common write-home-linux write-home-darwin add-home hm-apply write-nvim link-p10k install-chatgpt readme

bootstrap: nix-install flakes envrc write-flake write-home-common write-home-linux write-home-darwin add-home hm-apply write-nvim link-p10k
	@echo "✅ Full bootstrap complete. Open a new terminal, then: nix develop"

nix-install: ; bash scripts/010_nix_install.sh
flakes: ; bash scripts/011_enable_flakes.sh
direnv: ; bash scripts/012_install_direnv.sh
envrc: ; bash scripts/019_write_envrc.sh
write-flake: ; bash scripts/013_write_flake.sh
write-home-common: ; bash scripts/014_write_home_common.sh
write-home-linux: ; bash scripts/015_write_home_linux.sh
write-home-darwin: ; bash scripts/016_write_home_darwin.sh
add-home: ; bash scripts/017_add_home_config_entry.sh
hm-apply: ; bash scripts/018_apply_home_manager.sh
write-nvim: ; bash scripts/021_write_neovim_config.sh
link-p10k: ; bash scripts/022_link_p10k_theme.sh
install-chatgpt: ; bash scripts/030_install_chatgpt_cli.sh
readme: ; bash scripts/020_write_readme.sh
