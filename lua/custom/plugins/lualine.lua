return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      icons_enabled = true,
      -- "auto" follows the Omarchy theme
      theme = require("custom.omarchy").enabled and "auto" or "codedark",
      component_separators = "|",
      section_separators = "",
    },
    sections = {
      lualine_x = {
        {
          function()
            local ok, opencode = pcall(require, "opencode")
            if ok and opencode.statusline then
              return opencode.statusline()
            end
            return ""
          end,
        },
        "encoding",
        "fileformat",
        "filetype",
      },
    },
  },
}
