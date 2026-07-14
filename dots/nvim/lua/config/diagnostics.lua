-- Diagnostic Keymaps
vim.keymap.set("n", "<leader>dk", vim.diagnostic.goto_prev, { desc = "Diagnostic Go to previous message" })
vim.keymap.set("n", "<leader>dj", vim.diagnostic.goto_next, { desc = "Diagnostic Go to next message" })
vim.keymap.set("n", "<space>dd", vim.diagnostic.open_float, { desc = "Diagnostic Float" })
vim.keymap.set("n", "<space>qq", vim.diagnostic.setloclist, { desc = "Diagnostic LocList" })

-- Configure diagostics border and sign column icons
vim.diagnostic.config({
  float = {
    border = "rounded",
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})
