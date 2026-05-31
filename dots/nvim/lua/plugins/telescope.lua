return {
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.8',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }

    },
    config = function()
      require('telescope').setup {
        defaults = {
          sorting_strategy = "ascending",
          layout_config = {
            horizontal = { prompt_position = "top", height = 0.8 },
          },
          extensions = {
            fzf = {}
          },
          mappings = {
            i = {
              ["<c-x>"] = false,
              ["<c-v>"] = false,
              ["<c-l>"] = require("telescope.actions").select_vertical,
              ["<c-j>"] = require("telescope.actions").select_horizontal,
              ["<C-q>"] = require("telescope.actions").send_to_qflist,
              -- ["<cr>"] = require("telescope.actions").select_default
            },
            n = {
              -- ["q"] = require("telescope.actions").close,
              -- ["<c-x>"] = false,
              -- ["<c-v>"] = false,
              ["<c-l>"] = require("telescope.actions").select_vertical,
              ["<c-j>"] = require("telescope.actions").select_horizontal,
              ["<C-q>"] = require("telescope.actions").close,
              -- ["<cr>"] = require("telescope.actions").select_default
            }
          },
        }
      }

      require('telescope').load_extension('fzf')
      local bt = require('telescope.builtin')
      vim.keymap.set("n", "<space>fhe", bt.help_tags)
      vim.keymap.set("n", "<space>fhi", bt.highlights)
      vim.keymap.set("n", "<space>ff", bt.find_files)
      vim.keymap.set("n", "<leader>fw", bt.live_grep)
      vim.keymap.set("n", "<leader>fg", bt.git_files)
      vim.keymap.set("n", "<leader>fk", bt.keymaps)
      vim.keymap.set("n", "<leader>fb", bt.buffers)
      vim.keymap.set("n", "<space>en", function()
        require('telescope.builtin').find_files {
          cwd = vim.fn.stdpath("config")
        }
      end)
      vim.keymap.set("n", "<space>ep", function()
        require('telescope.builtin').find_files {
          cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy")
        }
      end)
    end
  }
}
