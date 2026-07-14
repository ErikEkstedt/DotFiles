-- Old config
-- https://github.com/ErikEkstedt/.files/blob/lazy/nvim/.config/nvim/init.lua
-- Neovim
vim.keymap.set("n", "<space>xx", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Options
vim.opt.number = true
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 4   -- Number of spaces for indentation
vim.opt.softtabstop = 4  -- Number of spaces per tab
vim.opt.tabstop = 4      -- Width of tab character
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99   -- Start with all folds open
vim.opt.wrap = false
vim.opt.scrolloff = 10   -- Always keep 10 rows visible above/below the cursor

-- Pick up file edits made on disk (e.g. by an external tool) silently,
-- instead of prompting to confirm the reload.
vim.opt.autoread = true

-- Makes visual block mode (C-v) work as expected
vim.opt.virtualedit = "block"


-- I: don't give the intro message when starting Vim, *shm-I* see |:intro|
vim.opt.shortmess:append('I')

-- Decides how new vertical/horizontal buffers open
vim.opt.splitbelow = false
vim.opt.splitright = true


-- Errors in numbers column should not change
-- the width too much
vim.opt.signcolumn = "yes:1"


-- Faster time to execute command
vim.opt.timeoutlen = 400 -- Time in milliseconds to wait for a mapped sequence to complete.


-- Optional: Show tabs and spaces
vim.opt.list = true
vim.opt.listchars = {
  tab = '→ ',
  trail = '·',
  extends = '▶',
  precedes = '◀',
}

-- Init lazy
require("config.lazy")
-- vim.cmd.colorscheme("catppuccin-frappe")
vim.g.material_style = "darker"
vim.cmd.colorscheme("material")

-- Custom Settings not loaded by lazy
require("config.diagnostics")
require("config.mappings")
require("config.autocmds")
-- Mouse menu
-- require("config.menu")
