return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
      view = {
        adaptive_size = true,
        side = "left",
      },
    }
  end,
  keys = {
    { "<leader>e", ":NvimTreeToggle<CR>", desc = "Toggle NvimTree" },
    { "<leader>f", ":NvimTreeFindFileToggle<CR>", desc = "Find file in NvimTree" },
  },
}
