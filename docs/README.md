# NeoVim PDE

A modern Personal Development Environment built on NeoVim 0.12.

## Quick Reference

| Key | Action |
|-----|--------|
| `,` | **Leader key** |
| `<Space>` | Secondary leader for search/LSP |
| `-` | File explorer (Oil) |
| `<leader>oa` | Ask opencode |
| `gd` | Go to definition |
| `K` | Hover docs |
| `<Space>sf` | Find files |
| `<Space>sg` | Live grep |
| `<leader>gg` | Lazygit |

## First Time Setup

### Debian / Ubuntu

```bash
git clone <this-repo> ~/nvim-config && cd ~/nvim-config
./scripts/setup.sh
```

Installs Neovim, the tree-sitter CLI, Node.js, lazygit and the system packages
this config needs, links `~/.config/nvim`, then syncs plugins, parsers and
language servers. Safe to re-run — every step is skipped if already satisfied.
`--help` lists the options; `--dry-run` shows what it would do.

Go, Python and Rust toolchains are **not** installed. Add them if you want
gopls/delve/templ, black/autoflake, or the sleek SQL formatter.

### macOS

```bash
brew install neovim tree-sitter-cli ripgrep fd lazygit node
```

### Then, in Neovim

```vim
:Lazy sync              " Install/update plugins
:MasonToolsInstall      " Install LSP servers, formatters and debug adapters
:checkhealth            " Verify everything is working
```

Treesitter parsers install automatically on startup; `:TSUpdate` refreshes them.
Requires the `tree-sitter` CLI and a C compiler.

## Documentation

- [Keymaps](keymaps.md) - Complete keyboard shortcut reference
- [Plugins](plugins.md) - Installed plugins and their features
- [Tips & Workflows](tips.md) - Productivity tips and common workflows

## Structure

```
~/.config/nvim/
├── init.lua                 # Entry point, lazy.nvim bootstrap
├── plugin/                  # Auto-loaded configs
│   ├── keymaps.lua         # Global keybindings
│   ├── options.lua         # Vim options
│   ├── terminal.lua        # Terminal settings
│   └── yank.lua            # Yank highlighting
└── lua/custom/
    ├── plugins/            # Plugin specifications
    ├── completion.lua      # nvim-cmp config
    ├── telescope.lua       # Telescope config
    ├── snippets.lua        # LuaSnip setup
    └── snippets/           # Custom snippets
        └── go.lua
```

## Features at a Glance

### Language Support
C, Go, Lua, Rust, Python, TypeScript/JavaScript, JSON, YAML, PHP, Svelte, Tailwind CSS, and more.

### Core Capabilities
- **LSP** - Intelligent code completion, diagnostics, refactoring
- **Treesitter** - Syntax highlighting, indentation, code-aware text objects
- **Fuzzy Finding** - Files, grep, symbols, keymaps via Telescope
- **Git** - Hunks, blame, staging via gitsigns + lazygit
- **Debugging** - DAP support for Go (delve) and C/C++/Rust (codelldb)
- **Sessions** - Auto-save and restore workspaces

### UI/UX
- Gruvbox Material theme with transparency
- Which-key for keymap discovery
- Trouble for diagnostics list
- Oil for file management
- opencode.nvim for in-editor AI assistance
