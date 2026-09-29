-- Default theme. On Omarchy the system theme is used instead, see `custom/omarchy.lua`.
return {
  "f4z3r/gruvbox-material.nvim",
  name = "gruvbox-material",
  cond = not require("custom.omarchy").enabled,
  lazy = false,
  priority = 1000,
  opts = {
    background = {
      transparent = true,
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
