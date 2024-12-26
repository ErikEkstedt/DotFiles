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

-- Options
vim.opt.number = true
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 4   -- Number of spaces for indentation
vim.opt.softtabstop = 4  -- Number of spaces per tab
vim.opt.tabstop = 4      -- Width of tab character
vim.opt.foldmethod = "indent"
vim.opt.foldlevel = 99   -- Start with all folds open

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

-- Init lazy
require("config.lazy")

-- Custom Settings not loaded by lazy
require("config.diagnostics")
-- Mouse menu
require("config.menu")
local tmux = require("config.tmux")




-- Mappings
local ns = { noremap = true, silent = true }

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

-- Nice defaults save/exit
vim.keymap.set("n", "<C-s>", ":w<CR>")
vim.keymap.set("n", "<C-c>", "<CR>")
vim.keymap.set("n", "<M-q>", ":q!<CR>")
vim.keymap.set('n', '<C-c>', '"+y', ns) -- copy
vim.keymap.set('v', '<C-c>', '"+y', ns)
-- Does not work on my mac? Karabiner?
-- vim.keymap.set('n', '<D-c>', '"+y', ns)
-- vim.keymap.set('v', '<D-c>', '"+y', ns)

-- Format
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
