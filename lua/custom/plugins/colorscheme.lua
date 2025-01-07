return {
  -- add gruvbox
  { "wittyjudge/gruvbox-material.nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-material",
    },
  },
}
-- return {
--   {
--     -- "folke/tokyonight.nvim",
--     -- "rose-pine/neovim",
--     "AlexvZyl/nordic.nvim",
--     lazy = false,
--     priority = 1000,
--     init = function()
--       -- vim.cmd.colorscheme "tokyonight-night"
--       -- vim.cmd.colorscheme "rose-pine"
--       require("nordic").setup {
--         transparent = {
--           -- Enable transparent background.
--           bg = true,
--           -- Enable transparent background for floating windows.
--           float = true,
--         },
--       }
--       require("nordic").load()
--
--       vim.cmd.hi "Comment gui=none"
--     end,
--   },
-- }
