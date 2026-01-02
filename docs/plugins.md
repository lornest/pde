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
Core LSP configuration with Mason for automatic server installation.

**Configured Servers:**
| Language | Server |
|----------|--------|
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
Portable package manager for LSP servers, formatters, and linters.

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

### flash.nvim
Enhanced motions with labels.

**Modes:**
- `s` - Jump to any character with 1-2 keystrokes
- `S` - Select treesitter nodes
- Works in operator-pending mode for actions like `ds` (delete surrounding)

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
Syntax highlighting and code understanding.

**Installed Parsers:**
bash, c, css, dockerfile, go, gomod, gosum, gowork, html, javascript, json, jsonc, lua, luadoc, markdown, markdown_inline, php, python, regex, rust, svelte, toml, tsx, typescript, vim, vimdoc, yaml, zig

### nvim-treesitter-textobjects
Code-aware text objects and movements.

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

**Auto-open:** DAP UI opens automatically on debug start.

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
