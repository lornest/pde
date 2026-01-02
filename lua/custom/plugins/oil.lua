return {
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local oil = require "oil"

      _G.CustomOilBar = function()
        local path = vim.fn.expand "%"
        path = path:gsub("oil://", "")
        return "  " .. vim.fn.fnamemodify(path, ":.")
      end

      oil.setup {
        default_file_explorer = true,
        columns = { "icon" },
        keymaps = {
          ["<C-h>"] = false,
          ["<C-l>"] = false,
          ["<C-k>"] = false,
          ["<C-j>"] = false,
          ["<M-h>"] = "actions.select_split",
          ["<M-v>"] = "actions.select_vsplit",
          ["<C-r>"] = "actions.refresh",
          ["q"] = "actions.close",
        },
        win_options = {
          winbar = "%{v:lua.CustomOilBar()}",
        },
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name)
            return name == ".git" or name == ".DS_Store"
          end,
        },
        float = {
          padding = 2,
          max_width = 100,
          max_height = 30,
          border = "rounded",
        },
      }

      vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      vim.keymap.set("n", "<leader>e", oil.toggle_float, { desc = "File Explorer" })
      vim.keymap.set("n", "<space>-", oil.toggle_float, { desc = "File Explorer (float)" })
    end,
  },
}
