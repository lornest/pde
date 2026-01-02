return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 300,
    spec = {
      { "<leader>a", group = "actions", icon = "" },
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>g", group = "git" },
      { "<leader>h", group = "git hunk" },
      { "<leader>s", group = "search" },
      { "<leader>u", group = "ui/toggle" },
      { "<leader>w", group = "workspace" },
      { "<leader>x", group = "diagnostics" },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "z", group = "fold" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show { global = false }
      end,
      desc = "Buffer Local Keymaps",
    },
  },
}
