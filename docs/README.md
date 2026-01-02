# NeoVim PDE

A modern Personal Development Environment built on NeoVim 0.11.

## Quick Reference

| Key | Action |
|-----|--------|
| `,` | **Leader key** |
| `<Space>` | Secondary leader for search/LSP |
| `-` | File explorer (Oil) |
| `s` | Flash jump |
| `gd` | Go to definition |
| `K` | Hover docs |
| `<Space>sf` | Find files |
| `<Space>sg` | Live grep |
| `<leader>gg` | Lazygit |

## First Time Setup

```vim
:Lazy sync              " Install/update plugins
:TSUpdate               " Install treesitter parsers
:MasonToolsInstall      " Install LSP servers
```

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
    └── snippets/           # Custom snippets
        └── go.lua
```

## Features at a Glance

### Language Support
Go, Lua, Rust, Python, TypeScript/JavaScript, JSON, YAML, PHP, Svelte, Tailwind CSS, and more.

### Core Capabilities
- **LSP** - Intelligent code completion, diagnostics, refactoring
- **Treesitter** - Syntax highlighting, text objects, incremental selection
- **Fuzzy Finding** - Files, grep, symbols, keymaps via Telescope
- **Git** - Hunks, blame, staging via gitsigns + lazygit
- **Debugging** - DAP support for Go (extensible)
- **Sessions** - Auto-save and restore workspaces

### UI/UX
- Gruvbox Material theme with transparency
- Which-key for keymap discovery
- Trouble for diagnostics list
- Flash for rapid navigation
- Oil for file management
