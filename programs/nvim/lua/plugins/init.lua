-- globals
local api = vim.api
local cmd = vim.cmd
local map = vim.keymap.set
local lsp = vim.lsp
local global_opt = vim.opt_global
local diag = vim.diagnostic

global_opt.clipboard = "unnamed"
global_opt.timeoutlen = 200

return {
  "folke/which-key.nvim",
  { "folke/neoconf.nvim", cmd = "Neoconf" }
}

