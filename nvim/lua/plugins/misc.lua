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
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("noice").setup({
        cmdline = { enabled = true },
        messages = { enabled = true },
        popupmenu = { enabled = true },
        notify = { enabled = false },
        lsp = {
          progress = { enabled = false },
          hover = { enabled = false },
          signature = { enabled = false },
          message = { enabled = false },
          documentation = { enabled = false },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = false,        -- use a classic bottom cmdline for search
          command_palette = false,      -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,           -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
      })
    end,
  }

}
