print("Minimal Config")

-- Neovim
vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Init lazy
require("config.lazy")

-- Custom tmux movement
local tmux = require("config.tmux")


-- Options
vim.opt.number = true
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 4   -- Number of spaces for indentation
vim.opt.softtabstop = 4  -- Number of spaces per tab
vim.opt.tabstop = 4      -- Width of tab character

-- Errors in numbers column should not change
-- the width too much
vim.opt.signcolumn = "yes:1"


-- Optional: Show tabs and spaces
vim.opt.list = true
vim.opt.listchars = {
  tab = '→ ',
  trail = '·',
  extends = '▶',
  precedes = '◀',
}


-- Mappings
local ns = { noremap = true, silent = true }

vim.keymap.set("n", "H", "^")
vim.keymap.set("n", "L", "$")
vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("n", "<M-q>", ":q!<CR>")

vim.keymap.set("n", "<space>fo", function() vim.lsp.buf.format() end)



-- TMUX
vim.keymap.set("n", "<M-h>", function() tmux.move_left() end, ns)
vim.keymap.set("n", "<M-j>", function() tmux.move_down() end, ns)
vim.keymap.set("n", "<M-k>", function() tmux.move_up() end, ns)
vim.keymap.set("n", "<M-l>", function() tmux.move_right() end, ns)


-- autocommands
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 150,
    })
  end,
})
