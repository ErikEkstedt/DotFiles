return {
  {
    "akinsho/nvim-toggleterm.lua",
    keys = {
      {
        "<leader>gg",
        function()
          local lazygit = require("toggleterm.terminal").Terminal:new({
            cmd = "lazygit",
            hidden = true,
            direction = "float",
            float_opts = {
              border = "rounded",
              height = math.floor(vim.o.lines * 0.9),
            },
          })

          -- this was default in the mapping whereas the above was created in the config
          -- It seems like the terminal is not consistent across pressig "q" to exit
          -- If this is possible we should change this keymapping function
          lazygit:toggle()
        end,
        desc = "LazyGit",
      },
    },
    config = function()
      require("toggleterm").setup({})
    end
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = "_" },
        topdelete    = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
  {
    "jpalardy/vim-slime",
    config = function()
      vim.g.slime_target = "tmux"
      vim.g.slime_default_config = { socket_name = "default", target_pane = "{right-of}" }
      vim.g.slime_python_ipython = 1
      vim.g.slime_no_mappings = 1

      --Required to transfer data from vim to GNU screen or tmux. Set to "$HOME/.slime_paste" by default.
      -- vim.g.slime_paste_file=vim.fn.tempname()

      vim.keymap.set("n", "<C-C><C-x>", "<Plug>SlimeConfig", {})
      vim.keymap.set("n", "<C-C><C-C>", "<Plug>SlimeLineSend", {})
      vim.keymap.set("x", "<C-C><C-C>", "<Plug>SlimeRegionSend", {})
    end,
  },
}
