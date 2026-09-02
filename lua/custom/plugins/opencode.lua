return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    "folke/snacks.nvim",
  },
  config = function()
    -- Required for opts.events.reload (live reload when opencode edits files)
    vim.o.autoread = true

    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Use snacks terminal as provider (since you already have snacks.nvim)
      provider = {
        enabled = "snacks",
      },
    }
  end,
  keys = {
    -- Core actions
    {
      "<leader>oa",
      function()
        require("opencode").ask()
      end,
      mode = { "n", "x" },
      desc = "Ask opencode",
    },
    {
      "<leader>os",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "Select opencode action",
    },
    {
      "<leader>oo",
      function()
        require("opencode").toggle()
      end,
      mode = { "n", "t" },
      desc = "Toggle opencode",
    },

    -- Operator for adding ranges to opencode
    {
      "go",
      function()
        return require("opencode").operator("@this ")
      end,
      mode = { "n", "x" },
      desc = "Add range to opencode",
      expr = true,
    },
    {
      "goo",
      function()
        return require("opencode").operator("@this ") .. "_"
      end,
      mode = "n",
      desc = "Add line to opencode",
      expr = true,
    },

    -- Quick prompts with context
    {
      "<leader>od",
      function()
        require("opencode").prompt("diagnostics")
      end,
      mode = { "n", "x" },
      desc = "Explain diagnostics",
    },
    {
      "<leader>of",
      function()
        require("opencode").prompt("fix")
      end,
      mode = { "n", "x" },
      desc = "Fix diagnostics",
    },
    {
      "<leader>or",
      function()
        require("opencode").prompt("review")
      end,
      mode = { "n", "x" },
      desc = "Review code",
    },
    {
      "<leader>oe",
      function()
        require("opencode").prompt("explain")
      end,
      mode = { "n", "x" },
      desc = "Explain code",
    },
    {
      "<leader>ot",
      function()
        require("opencode").prompt("test")
      end,
      mode = { "n", "x" },
      desc = "Add tests",
    },
    {
      "<leader>oi",
      function()
        require("opencode").prompt("implement")
      end,
      mode = { "n", "x" },
      desc = "Implement code",
    },

    -- Session controls
    {
      "<leader>on",
      function()
        require("opencode").command("session.new")
      end,
      desc = "New opencode session",
    },
    {
      "<leader>ol",
      function()
        require("opencode").command("session.list")
      end,
      desc = "List opencode sessions",
    },
    {
      "<leader>oq",
      function()
        require("opencode").command("session.interrupt")
      end,
      desc = "Interrupt opencode",
    },

    -- Scrolling opencode (when not focused)
    {
      "<S-C-u>",
      function()
        require("opencode").command("session.half.page.up")
      end,
      desc = "Scroll opencode up",
    },
    {
      "<S-C-d>",
      function()
        require("opencode").command("session.half.page.down")
      end,
      desc = "Scroll opencode down",
    },
  },
}
