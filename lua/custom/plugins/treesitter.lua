-- nvim-treesitter `main` branch.
--
-- The old `master` branch is frozen and explicitly does not support Neovim
-- 0.12, so this is the rewritten API: the plugin only installs parsers and
-- queries, and the features themselves (highlight/indent/fold) are enabled
-- per-filetype against Neovim's built-in treesitter support.
local ensure_installed = {
  "bash",
  "c",
  "css",
  "dockerfile",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "html",
  "javascript",
  "json", -- also backs `jsonc`
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "php",
  "python",
  "regex",
  "rust",
  "svelte",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "zig",
}

-- Highlighting these still wants the legacy regex syntax layered on top.
local additional_vim_regex_highlighting = {
  ruby = true,
}

-- Treesitter indentation is experimental and known-bad for these.
local disable_indent = {
  ruby = true,
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- `main` does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      local ts = require "nvim-treesitter"
      ts.setup {}

      ts.install(ensure_installed)

      -- `main` dropped the `auto_install` option, so do it by hand: on first
      -- sight of a filetype, install its parser if one is available.
      local installed = {}
      for _, lang in ipairs(ts.get_installed()) do
        installed[lang] = true
      end

      local available = {}
      for _, lang in ipairs(ts.get_available()) do
        available[lang] = true
      end

      local function enable(lang, buf)
        if not vim.api.nvim_buf_is_valid(buf) then
          return
        end

        if not pcall(vim.treesitter.start, buf, lang) then
          return
        end

        local ft = vim.bo[buf].filetype

        if not disable_indent[ft] then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end

        if additional_vim_regex_highlighting[ft] then
          vim.bo[buf].syntax = "on"
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("custom-treesitter", { clear = true }),
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if not lang or not available[lang] then
            return
          end

          if installed[lang] then
            enable(lang, args.buf)
            return
          end

          installed[lang] = true
          ts.install(lang):await(function(err)
            if err then
              installed[lang] = nil
              return
            end
            vim.schedule(function()
              enable(lang, args.buf)
            end)
          end)
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    event = "VeryLazy",
    config = function()
      require("nvim-treesitter-textobjects").setup {
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      }

      local select = require "nvim-treesitter-textobjects.select"
      local move = require "nvim-treesitter-textobjects.move"
      local swap = require "nvim-treesitter-textobjects.swap"

      local selections = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
      }

      for lhs, query in pairs(selections) do
        vim.keymap.set({ "x", "o" }, lhs, function()
          select.select_textobject(query, "textobjects")
        end, { desc = "Select " .. query })
      end

      local movements = {
        [move.goto_next_start] = { ["]f"] = "@function.outer", ["]c"] = "@class.outer", ["]a"] = "@parameter.inner" },
        [move.goto_next_end] = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
        [move.goto_previous_start] = { ["[f"] = "@function.outer", ["[c"] = "@class.outer", ["[a"] = "@parameter.inner" },
        [move.goto_previous_end] = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
      }

      for fn, maps in pairs(movements) do
        for lhs, query in pairs(maps) do
          vim.keymap.set({ "n", "x", "o" }, lhs, function()
            fn(query, "textobjects")
          end, { desc = "Goto " .. query })
        end
      end

      vim.keymap.set("n", "<leader>a", function()
        swap.swap_next "@parameter.inner"
      end, { desc = "Swap next parameter" })

      vim.keymap.set("n", "<leader>A", function()
        swap.swap_previous "@parameter.inner"
      end, { desc = "Swap previous parameter" })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    opts = {
      max_lines = 3,
    },
  },
}
