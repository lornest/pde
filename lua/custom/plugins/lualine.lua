return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      icons_enabled = true,
      theme = "codedark",
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
