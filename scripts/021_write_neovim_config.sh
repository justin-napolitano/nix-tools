#!/usr/bin/env bash
set -euo pipefail
NVIM_DIR="${HOME}/.config/nvim"
mkdir -p "$NVIM_DIR"/lua/plugins
[[ -e "$NVIM_DIR/init.lua" ]] && cp -a "$NVIM_DIR/init.lua" "$NVIM_DIR/init.lua.bak.$(date +%Y%m%d%H%M%S)"
cat > "$NVIM_DIR/init.lua" <<'LUA'
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  {"nvim-telescope/telescope.nvim", dependencies = {"nvim-lua/plenary.nvim"}},
  {"neovim/nvim-lspconfig"},
  {"hrsh7th/nvim-cmp", dependencies = {"hrsh7th/cmp-nvim-lsp", "L3MON4D3/LuaSnip"}},
  {"ellisonleao/gruvbox.nvim"},
})
vim.o.termguicolors = true
pcall(vim.cmd.colorscheme, "gruvbox")
local lspconfig = require("lspconfig")
lspconfig.tsserver.setup({})
lspconfig.pyright.setup({})
lspconfig.bashls.setup({})
lspconfig.lua_ls.setup({})
lspconfig.yamlls.setup({})
LUA
echo "[write-nvim] OK"
