return {
  {
    -- "folke/tokyonight.nvim",
    -- "rose-pine/neovim",
    "AlexvZyl/nordic.nvim",
    lazy = false,
    priority = 1000,
    init = function()
      -- vim.cmd.colorscheme "tokyonight-night"
      -- vim.cmd.colorscheme "rose-pine"
      require("nordic").load()

      vim.cmd.hi "Comment gui=none"
    end,
  },
}
