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
vim.cmd.colorscheme("catppuccin-frappe")

-- Custom Settings not loaded by lazy
require("config.diagnostics")
-- Mouse menu

-- require("config.menu")

-- Mappings
-- Used for mapping commands
local ns = { noremap = true, silent = true }


-- TMUX
vim.keymap.set("n", "<M-h>", function() require('config.tmux').move_left() end, ns)
vim.keymap.set("n", "<M-j>", function() require('config.tmux').move_down() end, ns)
vim.keymap.set("n", "<M-k>", function() require('config.tmux').move_up() end, ns)
vim.keymap.set("n", "<M-l>", function() require('config.tmux').move_right() end, ns)

-- Zoom
vim.keymap.set("n", "<space>z", function() require('config.zoom').maximize_current_split() end, ns)


-- Move end/start of line
vim.keymap.set("n", "L", "$", ns)
vim.keymap.set("n", "H", "^", ns)
vim.keymap.set("x", "L", "$", ns)
vim.keymap.set("x", "H", "^", ns)
vim.keymap.set("x", "J", "}", ns)
vim.keymap.set("x", "K", "{", ns)

-- Goto next under cursor
vim.keymap.set("n", "gn", "*zvzz", ns)
vim.keymap.set("n", "gN", "#zvzz", ns)

-- */# stays on current word
vim.keymap.set("n", "*", "*<C-o>", ns)
vim.keymap.set("n", "#", "#<C-o>", ns)

-- Buffer movement
vim.keymap.set("n", "<Leader>b", ":bp<CR>", ns)
vim.keymap.set("n", "<Leader>n", ":bn<CR>", ns)
vim.keymap.set("n", "<Leader>B", ":bf<CR>", ns)
vim.keymap.set("n", "<Leader>N", ":bl<CR>", ns)
vim.keymap.set("n", "<Leader><Leader>", ":b#<CR>", ns)
-- vim.keymap.set("n", "<Leader>D", ":bd<CR>", ns)

-- Tab key behavior
vim.keymap.set("v", "<Tab>", ">gv", { silent = true })
vim.keymap.set("v", "<S-Tab>", "<gv", { silent = true })
vim.keymap.set("i", "<S-Tab>", "<esc><<I", { silent = true })

-- Nice defaults save/exit
vim.keymap.set("n", "<C-s>", "<cmd>w<CR>", ns)
vim.keymap.set("n", "<C-c>", "<CR>")
vim.keymap.set("n", "<C-q>", ":q!<CR>")
vim.keymap.set("n", "<M-q>", ":q!<CR>")
vim.keymap.set('n', '<C-c>', '"+y', ns) -- copy
vim.keymap.set('v', '<C-c>', '"+y', ns)
-- Does not work on my mac? Karabiner?
-- vim.keymap.set('n', '<D-c>', '"+y', ns)
-- vim.keymap.set('v', '<D-c>', '"+y', ns)

-- Buffer movement
-- vim.keymap.set("n", "<space><space>", "<cmd>b#<CR>")
vim.keymap.set("n", "<space><space>", ":b#<CR>", ns)


-- Format
vim.keymap.set("n", "<space>fo", function() vim.lsp.buf.format() end)


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

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = vim.api.nvim_create_augroup("kickstart-auto-create-dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("kickstart-checktime", { clear = true }),
  command = "checktime",
})
