return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      { "j-hui/fidget.nvim", opts = {} },
      { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },

      "stevearc/conform.nvim",
      "b0o/SchemaStore.nvim",

      { "smjonas/inc-rename.nvim", opts = {} },
      {
        "aznhe21/actions-preview.nvim",
        opts = {
          telescope = {
            sorting_strategy = "ascending",
            layout_strategy = "vertical",
            layout_config = {
              width = 0.8,
              height = 0.9,
              prompt_position = "top",
              preview_cutoff = 20,
              preview_height = function(_, _, max_lines)
                return max_lines - 15
              end,
            },
          },
        },
      },
    },
    config = function()
      if vim.g.obsidian then
        return
      end

      -- Per-server overrides. `true` means "install it, use the defaults that
      -- nvim-lspconfig ships in its `lsp/` directory".
      local servers = {
        bashls = true,
        clangd = true,
        gopls = {
          settings = {
            gopls = {
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
        lua_ls = {
          server_capabilities = {
            semanticTokensProvider = vim.NIL,
          },
        },
        rust_analyzer = true,
        svelte = true,
        templ = true,
        taplo = true,
        intelephense = true,

        pyright = true,
        mojo = { manual_install = true },

        biome = true,
        ts_ls = {
          server_capabilities = {
            documentFormattingProvider = false,
          },
        },
        jsonls = {
          server_capabilities = {
            documentFormattingProvider = false,
          },
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },

        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },

        tailwindcss = {
          init_options = {
            userLanguages = {
              elixir = "phoenix-heex",
              eruby = "erb",
              heex = "phoenix-heex",
            },
          },
          settings = {
            tailwindCSS = {
              experimental = {
                classRegex = {
                  [[class: "([^"]*)]],
                },
              },
            },
          },
        },
      }

      local servers_to_install = vim.tbl_filter(function(key)
        local t = servers[key]
        if type(t) == "table" then
          return not t.manual_install
        else
          return t
        end
      end, vim.tbl_keys(servers))

      require("mason").setup()
      local ensure_installed = {
        "stylua",
        "lua_ls",
        "delve",
        "codelldb",
        -- "tailwind-language-server",
      }

      vim.list_extend(ensure_installed, servers_to_install)
      require("mason-tool-installer").setup { ensure_installed = ensure_installed }

      -- Broadcast the extra completion capabilities from nvim-cmp to every
      -- server. `vim.lsp.config('*', ...)` is merged into all configs.
      if pcall(require, "cmp_nvim_lsp") then
        vim.lsp.config("*", {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),
        })
      end

      -- `server_capabilities` is our own key, handled in LspAttach below, so
      -- strip it before handing the table to vim.lsp.config.
      for name, config in pairs(servers) do
        if type(config) == "table" then
          local settings = vim.deepcopy(config)
          settings.manual_install = nil
          settings.server_capabilities = nil
          if not vim.tbl_isempty(settings) then
            vim.lsp.config(name, settings)
          end
        end
      end

      -- mason-lspconfig enables every server it installs (`automatic_enable`),
      -- so we only need to enable the ones Mason does not manage.
      require("mason-lspconfig").setup()

      -- mason-lspconfig only auto-enables servers that Mason itself installed,
      -- so anything provided by the system is configured but never started.
      -- That is not hypothetical: Mason has no clangd build for linux_arm64,
      -- where clangd comes from the distro instead. Enable any server whose
      -- command actually resolves; vim.lsp.enable is idempotent, so overlapping
      -- with mason-lspconfig is harmless.
      for name, config in pairs(servers) do
        if config ~= false then
          local manual = type(config) == "table" and config.manual_install
          local resolved = vim.lsp.config[name]
          local cmd = resolved and resolved.cmd
          local exe = type(cmd) == "table" and cmd[1] or nil

          if manual or (exe and vim.fn.executable(exe) == 1) then
            vim.lsp.enable(name)
          end
        end
      end

      local disable_semantic_tokens = {
        lua = true,
      }

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local bufnr = args.buf
          local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

          local settings = servers[client.name]
          if type(settings) ~= "table" then
            settings = {}
          end

          local builtin = require "telescope.builtin"

          vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
          vim.keymap.set("n", "gd", builtin.lsp_definitions, { buffer = bufnr, desc = "Goto Definition" })
          vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = bufnr, desc = "Goto References" })
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "Goto Declaration" })
          vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = bufnr, desc = "Goto Type Definition" })
          vim.keymap.set("n", "gI", builtin.lsp_implementations, { buffer = bufnr, desc = "Goto Implementation" })
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr, desc = "Hover Documentation" })
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = bufnr, desc = "Signature Help" })

          vim.keymap.set("n", "<leader>cr", function()
            return ":IncRename " .. vim.fn.expand "<cword>"
          end, { buffer = bufnr, desc = "Rename Symbol", expr = true })
          vim.keymap.set({ "n", "v" }, "<space>ca", require("actions-preview").code_actions, { buffer = bufnr, desc = "Code Action" })
          vim.keymap.set("n", "<space>wd", builtin.lsp_document_symbols, { buffer = bufnr, desc = "Document Symbols" })
          vim.keymap.set("n", "<space>ws", builtin.lsp_dynamic_workspace_symbols, { buffer = bufnr, desc = "Workspace Symbols" })

          local filetype = vim.bo[bufnr].filetype
          if disable_semantic_tokens[filetype] then
            client.server_capabilities.semanticTokensProvider = nil
          end

          -- Override server capabilities
          if settings.server_capabilities then
            for k, v in pairs(settings.server_capabilities) do
              if v == vim.NIL then
                ---@diagnostic disable-next-line: cast-local-type
                v = nil
              end

              client.server_capabilities[k] = v
            end
          end
        end,
      })

      -- Autoformatting Setup
      local conform = require "conform"
      conform.setup {
        formatters_by_ft = {
          lua = { "stylua" },
          blade = { "blade-formatter" },
          python = { "autoflake", "black" },
        },
      }

      conform.formatters.injected = {
        options = {
          ignore_errors = false,
          lang_to_formatters = {
            sql = { "sleek" },
          },
        },
      }

      vim.api.nvim_create_autocmd("BufWritePre", {
        callback = function(args)
          -- local filename = vim.fn.expand "%:p"

          local extension = vim.fn.expand "%:e"
          if extension == "mlx" then
            return
          end

          require("conform").format {
            bufnr = args.buf,
            lsp_format = "fallback",
            quiet = true,
          }
        end,
      })

      require("lsp_lines").setup()
      vim.diagnostic.config {
        virtual_text = true,
        virtual_lines = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "󰅚",
            [vim.diagnostic.severity.WARN] = "󰀪",
            [vim.diagnostic.severity.HINT] = "󰌶",
            [vim.diagnostic.severity.INFO] = "󰋽",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
        },
      }

      vim.keymap.set("", "<leader>l", function()
        local config = vim.diagnostic.config() or {}
        if config.virtual_text then
          vim.diagnostic.config { virtual_text = false, virtual_lines = true }
        else
          vim.diagnostic.config { virtual_text = true, virtual_lines = false }
        end
      end, { desc = "Toggle lsp_lines" })
    end,
  },
}
