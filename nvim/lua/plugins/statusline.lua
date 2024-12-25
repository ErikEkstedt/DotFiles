return {
  {
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
      require("mini.statusline").setup({ use_icons = true })
      require("mini.tabline").setup({ use_icons = true })
    end
  },
}
