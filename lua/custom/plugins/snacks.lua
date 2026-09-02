return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "g", desc = "Live Grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = " ", key = "s", desc = "Restore Session", action = ":lua require('persistence').load()" },
          { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
      sections = {
        {
          text = {
            { "█▀▀▄ █▀▀▀ █▀▀█ ", hl = "SnacksDashboardMuted" },
            { "█  █ █ █▀▄▀█", hl = "SnacksDashboardBold" },
          },
          align = "center",
          padding = 0,
        },
        {
          text = {
            { "█  █ █▀▀▀ █  █ ", hl = "SnacksDashboardMuted" },
            { "▀▄▄▀ █ █   █", hl = "SnacksDashboardBold" },
          },
          align = "center",
          padding = 0,
        },
        {
          text = {
            { "▀  ▀ ▀▀▀▀ ▀▀▀▀ ", hl = "SnacksDashboardMuted" },
            { " ▀▀  ▀ ▀   ▀", hl = "SnacksDashboardBold" },
          },
          align = "center",
          padding = 1,
        },
        { section = "keys", gap = 1, padding = 1 },
      },
    },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 3000,
    },
    picker = { enabled = true },
    quickfile = { enabled = true },
    terminal = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    styles = {
      notification = {
        -- wo = { wrap = true } -- Wrap notifications
      },
    },
  },
  keys = {
    {
      "<leader>a",
      function()
        local actions = {
          {
            name = "  Find File",
            action = function()
              Snacks.dashboard.pick "files"
            end,
          },
          {
            name = "  Find Text",
            action = function()
              Snacks.dashboard.pick "live_grep"
            end,
          },
          {
            name = "  Recent Files",
            action = function()
              Snacks.dashboard.pick "oldfiles"
            end,
          },
          {
            name = "  Config",
            action = function()
              Snacks.dashboard.pick("files", { cwd = vim.fn.stdpath "config" })
            end,
          },
          {
            name = "  Restore Session",
            action = function()
              require("persistence").load()
            end,
          },
          {
            name = "  Select Session",
            action = function()
              require("persistence").select()
            end,
          },
          {
            name = "󰒲  Lazy",
            action = function()
              vim.cmd "Lazy"
            end,
          },
          {
            name = "  New File",
            action = function()
              vim.cmd "ene | startinsert"
            end,
          },
          {
            name = "  Quit",
            action = function()
              vim.cmd "qa"
            end,
          },
        }
        vim.ui.select(actions, {
          prompt = "Actions",
          format_item = function(item)
            return item.name
          end,
        }, function(choice)
          if choice then
            choice.action()
          end
        end)
      end,
      desc = "Actions",
    },
    {
      "<leader>z",
      function()
        Snacks.zen()
      end,
      desc = "Toggle Zen Mode",
    },
    {
      "<leader>Z",
      function()
        Snacks.zen.zoom()
      end,
      desc = "Toggle Zoom",
    },
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Toggle Scratch Buffer",
    },
    {
      "<leader>S",
      function()
        Snacks.scratch.select()
      end,
      desc = "Select Scratch Buffer",
    },
    {
      "<leader>n",
      function()
        Snacks.notifier.show_history()
      end,
      desc = "Notification History",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },
    {
      "<leader>gB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
      mode = { "n", "v" },
    },
    {
      "<leader>gb",
      function()
        Snacks.git.blame_line()
      end,
      desc = "Git Blame Line",
    },
    {
      "<leader>gf",
      function()
        Snacks.lazygit.log_file()
      end,
      desc = "Lazygit Current File History",
    },
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>gl",
      function()
        Snacks.lazygit.log()
      end,
      desc = "Lazygit Log (cwd)",
    },
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },
    {
      "<c-`>",
      function()
        Snacks.terminal()
      end,
      desc = "Toggle Terminal",
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Next Reference",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Prev Reference",
      mode = { "n", "t" },
    },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win {
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        }
      end,
    },
  },
  init = function()
    local function set_dashboard_hl()
      vim.api.nvim_set_hl(0, "SnacksDashboardMuted", { fg = "#7c6f64" })
      vim.api.nvim_set_hl(0, "SnacksDashboardBold", { fg = "#8ec07c", bold = true })
      vim.api.nvim_set_hl(0, "SnacksDashboardKey", { fg = "#fe8019", bold = true })
      vim.api.nvim_set_hl(0, "SnacksDashboardDesc", { fg = "#a89984" })
    end
    vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, { callback = set_dashboard_hl })
    vim.schedule(set_dashboard_hl)

    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
        Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>uL"
        Snacks.toggle.diagnostics():map "<leader>ud"
        Snacks.toggle.line_number():map "<leader>ul"
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map "<leader>uc"
        Snacks.toggle.treesitter():map "<leader>uT"
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map "<leader>ub"
        Snacks.toggle.inlay_hints():map "<leader>uh"
        Snacks.toggle.indent():map "<leader>ug"
        Snacks.toggle.dim():map "<leader>uD"
      end,
    })
  end,
}
