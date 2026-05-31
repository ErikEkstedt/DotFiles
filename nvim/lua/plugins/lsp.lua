local kind_icons = {
  Copilot = "",
  Text = '󰉿',
  Method = '󰊕',
  Function = '󰊕',
  Constructor = '󰒓',
  Field = '󰜢',
  Variable = '󰆦',
  Property = '󰖷',
  Class = '󱡠',
  Interface = '󱡠',
  Struct = '󱡠',
  Module = '󰅩',
  Unit = '󰪚',
  Value = '󰦨',
  Enum = '󰦨',
  EnumMember = '󰦨',
  Keyword = '󰻾',
  Constant = '󰏿',
  Snippet = '󱄽',
  Color = '󰏘',
  File = '󰈔',
  Reference = '󰬲',
  Folder = '󰉋',
  Event = '󱐋',
  Operator = '󰪚',
  TypeParameter = '󰬛',
}

return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
      {
        'saghen/blink.cmp',
        dependencies = {
          'rafamadriz/friendly-snippets',
          "giuxtaposition/blink-cmp-copilot",
        },
        version = '*',
        opts = {
          completion = {
            menu = { border = 'single' },
            documentation = { window = { border = 'single' } },
          },
          signature = { window = { border = 'single' } },
          keymap = {
            ['<S-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
            ['<C-e>'] = { 'hide', 'fallback' },
            ['<Tab>'] = {
              function(cmp)
                if cmp.snippet_active() then
                  return cmp.accept()
                else
                  return cmp.select_and_accept()
                end
              end,
              'snippet_forward',
              'fallback'
            },
            ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
            ['<Up>'] = { 'select_prev', 'fallback' },
            ['<Down>'] = { 'select_next', 'fallback' },
            ['<C-p>'] = { 'select_prev', 'fallback' },
            ['<C-n>'] = { 'select_next', 'fallback' },
            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
          },
          sources = {
            default = { "lsp", "path", "snippets", "buffer", "copilot" },
            providers = {
              copilot = {
                name = "copilot",
                module = "blink-cmp-copilot",
                score_offset = 100,
                async = true,
                transform_items = function(_, items)
                  local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                  local kind_idx = #CompletionItemKind + 1
                  CompletionItemKind[kind_idx] = "Copilot"
                  for _, item in ipairs(items) do
                    item.kind = kind_idx
                  end
                  return items
                end,
              },
            },
          },
          -- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
          appearance = { kind_icons = kind_icons },
        },
      },
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      {
        "zbirenbaum/copilot.lua",
        event = { "InsertEnter" },
        build = ":Copilot auth",
        opts = {
          suggestion = {
            enabled = false,
            auto_trigger = true,
            debounce = 75,
            -- keymap = {
            --   accept = "<C-l>",
            -- },
          },
          panel = { enabled = false },
          filetypes = {
            markdown = true,
            help = false,
          },
        },
      },
    },
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      require("mason").setup()
      require("mason-lspconfig").setup()
      require("lspconfig").lua_ls.setup { capabilities = capabilities }
      require 'lspconfig'.pyright.setup {
        -- Overwriting this only to have a better order (i.e., pyright first)
        -- Accidently had a setup.py in my home directory and all projects were thought to start there
        -- This should not be the case of course but lets not check the entire system for files I
        -- don't use as much as pyrightconfig.json / requirements.txt / setup
        root_dir = function(fname)
          local root_files = {
            "pyrightconfig.json",
            "requirements.txt",
            "setup.py",
            "pyproject.toml",
            "setup.cfg",
            ".git",
            "Pipfile",
          }
          return require("lspconfig.util").root_pattern(unpack(root_files))(fname)
        end,
        settings = {
          python = {
            venvPath = vim.fn.expand("$HOME/miniconda3/envs"),
            pythonPath = vim.g.python3_host_prog,
          },
        },
      }

      -- Autocommand to format on save
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local c = vim.lsp.get_client_by_id(args.data.client_id)
          if not c then return end

          if vim.bo.filetype == "lua" then
            -- Format the current buffer on save
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = args.buf,
              callback = function()
                vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
              end,
            })
          end
        end,
      })
    end
  },
}
