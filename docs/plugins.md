# Plugins

## Plugin Manager

### lazy.nvim
The modern plugin manager for NeoVim. Plugins are lazy-loaded for fast startup.

**Commands:**
- `:Lazy` - Open plugin manager UI
- `:Lazy sync` - Install, update, and clean plugins
- `:Lazy health` - Check plugin health

---

## LSP & Completion

### nvim-lspconfig
Server configurations for Neovim's built-in LSP client, with Mason for automatic
installation.

Servers are declared with `vim.lsp.config()` and enabled with `vim.lsp.enable()`
(Neovim 0.11+). The legacy `require('lspconfig').<server>.setup{}` framework is
deprecated upstream and is no longer used here. `mason-lspconfig` enables each
installed server automatically; per-server overrides live in the `servers` table
in `lua/custom/plugins/lsp.lua`.

**Configured Servers:**
| Language | Server |
|----------|--------|
| C / C++ | clangd |
| Go | gopls (with inlay hints) |
| Lua | lua_ls |
| Rust | rust_analyzer |
| Python | pyright |
| TypeScript/JS | ts_ls |
| JSON | jsonls (with SchemaStore) |
| YAML | yamlls (with SchemaStore) |
| PHP | intelephense |
| Svelte | svelte |
| Tailwind | tailwindcss |
| Bash | bashls |
| TOML | taplo |

### mason.nvim
Portable package manager for LSP servers, formatters, linters, and debug adapters.
Now maintained under the `mason-org` organisation (previously `williamboman`).

**Commands:**
- `:Mason` - Open Mason UI
- `:MasonToolsInstall` - Install all configured tools

### nvim-cmp
Completion engine with multiple sources.

**Sources (in priority order):**
1. `lazydev` - Lua development
2. `nvim_lsp` - Language server
3. `luasnip` - Snippets
4. `path` - File paths
5. `buffer` - Buffer words
6. `cmdline` - Command line

**Features:**
- Ghost text preview
- Bordered completion menu
- Documentation window
- Cmdline completion (`:` and `/`)

### conform.nvim
Formatting on save.

**Formatters:**
| Language | Formatter |
|----------|-----------|
| Lua | stylua |
| Python | autoflake, black |
| Blade | blade-formatter |

Anything without an explicit formatter falls back to LSP formatting
(`lsp_format = "fallback"`). C/C++ is formatted by clangd this way, which honours
a project's `.clang-format` file.

### lazydev.nvim
Enhanced Lua development with proper type support for NeoVim APIs.

### inc-rename.nvim
Live preview of rename refactoring. See changes as you type.

### actions-preview.nvim
Preview code actions before applying. Uses Telescope for selection.

### lsp_lines.nvim
Show diagnostics as virtual lines below the code. Toggle with `<leader>l`.

### fidget.nvim
Shows LSP progress in the bottom-right corner.

---

## Navigation & Search

### telescope.nvim
Fuzzy finder for everything.

**Extensions:**
- `fzf-native` - Faster sorting
- `ui-select` - Use telescope for vim.ui.select
- `smart-history` - Persistent search history

### oil.nvim
File explorer that works like a buffer. Edit filenames, delete files, create directories - all with normal vim commands.

**Features:**
- Hidden file display
- Custom winbar showing current path
- Hides `.git` and `.DS_Store`

### trouble.nvim
Pretty diagnostics, references, and quickfix lists.

---

## Treesitter

### nvim-treesitter
Installs tree-sitter parsers and queries. Tracks the **`main`** branch — the old
`master` branch is frozen and does not support Neovim 0.12.

On `main` the plugin *only* manages parsers and queries; the features themselves
are enabled per-filetype by a `FileType` autocmd in
`lua/custom/plugins/treesitter.lua`:

| Feature | Provided by |
|---------|-------------|
| Highlighting | `vim.treesitter.start()` (Neovim core) |
| Indentation | `nvim-treesitter`'s `indentexpr()` |
| Injections | Neovim core, no setup needed |

Parsers install to `~/.local/share/nvim/site/parser/`. Requires the
`tree-sitter` CLI (`brew install tree-sitter-cli`) and a C compiler.

Parsers not in the list below are installed automatically the first time you open
a matching filetype.

**Installed Parsers:**
bash, c, css, dockerfile, go, gomod, gosum, gowork, html, javascript, json, lua,
luadoc, markdown, markdown_inline, php, python, regex, rust, svelte, toml, tsx,
typescript, vim, vimdoc, yaml, zig

> `jsonc` uses the `json` parser, so it is not listed separately.
> Incremental selection (`<C-Space>`) was removed — `main` dropped that module.

### nvim-treesitter-textobjects
Code-aware text objects and movements. Also tracks the **`main`** branch;
keymaps are defined explicitly in `lua/custom/plugins/treesitter.lua` rather
than through a config table.

**Text Objects:**
- Functions (`af`, `if`)
- Classes (`ac`, `ic`)
- Arguments (`aa`, `ia`)
- Conditionals (`ai`, `ii`)
- Loops (`al`, `il`)

### nvim-treesitter-context
Shows current function/class context at top of window.

---

## Git

### gitsigns.nvim
Git integration in the sign column.

**Features:**
- Hunk signs (add, change, delete)
- Stage/unstage hunks
- Inline blame
- Hunk text object (`ih`)

### Snacks Git (via snacks.nvim)
- Lazygit integration
- Git browse (open in browser)
- Blame line

---

## UI & UX

### snacks.nvim
Collection of small utilities by Folke.

**Modules:**
| Module | Description |
|--------|-------------|
| bigfile | Disable features for large files |
| dashboard | Start screen |
| indent | Indentation guides |
| input | Better vim.ui.input |
| notifier | Notification system |
| picker | Fuzzy picker |
| quickfile | Fast file opener |
| scroll | Smooth scrolling |
| statuscolumn | Enhanced status column |
| words | Highlight word under cursor |
| zen | Distraction-free mode |
| terminal | Floating terminal |
| scratch | Scratch buffers |
| lazygit | Git UI integration |
| toggle | Easy option toggles |

### which-key.nvim
Popup showing available keybindings.

**Groups:**
- `<leader>b` - buffer
- `<leader>c` - code
- `<leader>g` - git
- `<leader>h` - git hunk
- `<leader>s` - search
- `<leader>u` - ui/toggle
- `<leader>w` - workspace
- `<leader>x` - diagnostics
- `<leader>q` - session

### lualine.nvim
Fast statusline with codedark theme.

### indent-blankline.nvim
Indentation guides with scope highlighting.

### nvim-colorizer.lua
Highlight color codes in files.

**Supports:**
- Hex colors (#fff, #ffffff, #ffffffff)
- RGB/HSL functions
- Named colors
- Tailwind classes

### gruvbox-material.nvim
Colorscheme with transparent background support.

---

## Editing

### mini.nvim
Collection of minimal modules.

**Modules:**
| Module | Description |
|--------|-------------|
| mini.ai | Extended text objects |
| mini.surround | Add/delete/replace surroundings |
| mini.pairs | Auto-close brackets |
| mini.splitjoin | Split/join arguments |

### todo-comments.nvim
Highlight and search TODO, FIXME, NOTE, etc.

**Navigation:**
- `]t` - Next todo
- `[t` - Previous todo

### LuaSnip
Snippet engine with custom snippets.

**Custom Snippets:**
- Go: `ge` - Error handling template

---

## Debugging

### nvim-dap
Debug Adapter Protocol support.

**Extensions:**
- `nvim-dap-go` - Go debugging with Delve
- `nvim-dap-ui` - Debugging UI
- `nvim-dap-virtual-text` - Inline variable values

**Adapters:**
| Languages | Adapter |
|-----------|---------|
| Go | delve (via `nvim-dap-go`) |
| C / C++ / Rust | codelldb |

Both are installed by Mason. The codelldb launch configuration prompts for the
binary to run and remembers it for the rest of the session.

**Auto-open:** DAP UI opens automatically on debug start.

---

## AI Assistance

### opencode.nvim
Drives an [opencode](https://opencode.ai) session from inside Neovim, rendered in
a snacks terminal.

**Features:**
- Ask about, review, explain, test or fix the current buffer or selection
- `go` operator to send an arbitrary range as context
- Session management (new, list, interrupt)
- Live reload when opencode edits files on disk (`autoread`)
- Status shown in lualine

See [Keymaps](keymaps.md#opencode-ai-assistant) for the full `<leader>o` list.

---

## Session Management

### persistence.nvim
Automatic session saving and restoration.

**Auto-saves:**
- On NeoVim exit
- Per-directory sessions

---

## Dependencies

### nvim-web-devicons
File type icons.

### plenary.nvim
Lua utilities used by many plugins.

### nvim-nio
Async IO for nvim-dap-ui.

### sqlite.lua
SQLite bindings for telescope history.

### SchemaStore.nvim
JSON/YAML schema catalog for better validation.
