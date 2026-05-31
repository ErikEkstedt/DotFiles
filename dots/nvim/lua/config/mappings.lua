-- Mappings
-- Used for mapping commands
local ns = { noremap = true, silent = true }


-- TMUX
local tmux = require("config.tmux")
vim.keymap.set("n", "<M-h>", function() tmux.move_left() end, ns)
vim.keymap.set("n", "<M-j>", function() tmux.move_down() end, ns)
vim.keymap.set("n", "<M-k>", function() tmux.move_up() end, ns)
vim.keymap.set("n", "<M-l>", function() tmux.move_right() end, ns)

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
vim.keymap.set("n", "<Leader>P", ":bf<CR>", ns)
vim.keymap.set("n", "<Leader>p", ":bp<CR>", ns)
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
vim.keymap.set('n', '<D-c>', function() print("D") end, ns)
vim.keymap.set('n', '<T-c>', function() print("T") end, ns)
vim.keymap.set('n', '<A-c>', function() print("A") end, ns)
-- vim.keymap.set('v', '<D-c>', '"+y', ns)

-- Buffer movement
-- vim.keymap.set("n", "<space><space>", "<cmd>b#<CR>")
vim.keymap.set("n", "<space><space>", ":b#<CR>", ns)


-- Format
vim.keymap.set("n", "<space>fo", function() vim.lsp.buf.format() end)
