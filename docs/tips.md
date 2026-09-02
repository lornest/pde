# Tips & Workflows

## Getting Started

### First Launch Checklist
```vim
:Lazy sync              " Install all plugins
:MasonToolsInstall      " Install LSP servers, formatters and debug adapters
:checkhealth            " Verify everything is working
```

Treesitter parsers install themselves on startup (and on first sight of a new
filetype), so there is nothing to run for them. Use `:TSUpdate` to refresh
parsers after a plugin update, and `:checkhealth nvim-treesitter` to inspect them.

Requires the `tree-sitter` CLI on your `PATH` (`brew install tree-sitter-cli`).

### Finding Your Way
- Press `<leader>?` to see all buffer-local keymaps
- Start typing a leader sequence and wait for which-key popup
- Use `<Space>sk` to search all keymaps
- Use `<Space>sh` to search help

---

## Navigation Workflows

### Finding Files
```
<Space>sf       → Find by filename
<Space>s.       → Recent files
<Space>sg       → Search file contents
<Space><Space>  → Switch buffers
```

### Code Navigation
```
gd      → Jump to definition
gr      → Find all references
gI      → Find implementations
<C-o>   → Jump back
<C-i>   → Jump forward
```

### File Explorer
- `-` from any buffer opens the parent directory
- Edit filenames like a buffer, then save to rename
- Use `d` to delete, create new files by typing names

---

## Code Editing

### Rename Symbol Everywhere
1. Place cursor on symbol
2. Press `<leader>cr`
3. Type new name (see preview)
4. Press `<CR>` to confirm

### Code Actions
1. On a diagnostic or code location
2. Press `<Space>ca`
3. Preview the action in Telescope
4. Press `<CR>` to apply

### Multi-cursor Alternative
Select a code-aware region, then substitute inside it:
```
vaf          → Visually select the whole function
vic          → Visually select inside a class
:s/old/new/g → Substitute within the selection
```

**Note:** treesitter incremental selection (`<C-Space>`) was removed when
nvim-treesitter moved to its `main` branch. Use the text objects above, or
`mini.ai` (`va)`, `vi"`, …), to select regions instead.

### Surround Operations
```
gsaiw"   → Add " around word
gsd"     → Delete surrounding "
gsr"'    → Replace " with '
```

### Split/Join
```
gS      → Toggle between single-line and multi-line
```
Works on function arguments, arrays, objects, etc.

---

## Git Workflow

### Quick Commit Flow
```
<leader>gg      → Open Lazygit
                  (stage, commit, push all in one UI)
```

### Hunk-by-Hunk Review
```
]h              → Next change
<leader>hp      → Preview the change
<leader>hs      → Stage just this hunk
[h              → Previous change
```

### Blame Investigation
```
<leader>hb      → See who wrote this line
<leader>hB      → Toggle persistent blame
<leader>gB      → Open file in GitHub/GitLab
```

### Resolving Conflicts
```
<leader>hd      → Diff current file
:Gitsigns diffthis ~1   → Diff against previous commit
```

---

## Debugging

Adapters: **delve** for Go, **codelldb** for C/C++/Rust.

### Basic Debug Session
1. Set breakpoint: `<Space>b`
2. Start debugging: `:DapContinue` or `F1`
3. Step through: `F2` (into), `F3` (over), `F4` (out)
4. Inspect variable: `<Space>?`

### Debug Current Test (Go)
```vim
:lua require('dap-go').debug_test()
```

### Debugging C/C++/Rust
`F1` prompts for the binary to launch (with file completion) and for any
arguments. The path is remembered for the rest of the session, so subsequent
runs just need `F1`.

**macOS: build with debug info that survives linking.** Clang leaves DWARF in the
`.o` files rather than the executable. A one-step build compiles to a *temporary*
object file and deletes it during linking, taking the debug info with it — the
binary runs fine but **no breakpoint will ever bind**:

```
warning: no debug symbols in executable (-arch arm64)
```

Either keep the object files (compile and link as separate steps, which any
normal Makefile or CMake build already does), or run `dsymutil <binary>` after
linking while the `.o` files still exist.

If a breakpoint is accepted but never hits, check for debug symbols before
suspecting the config.

---

## Session Management

### Auto-save Sessions
Sessions are saved automatically per directory.

### Restore Workflow
```
nvim                    → Opens fresh
<leader>ql              → Restore last session
<leader>qS              → Pick a session
```

### Session Tips
- Sessions remember: buffers, windows, tabs, cursor positions
- Use `<leader>qd` before closing if you don't want to save

---

## Diagnostics & Errors

### Toggle Diagnostic Display
```
<leader>l       → Toggle between inline and multiline diagnostics
<leader>ud      → Hide/show all diagnostics
```

### Navigate Errors
```
]d / [d         → Next/prev diagnostic
<leader>xx      → Open Trouble list
]q / [q         → Next/prev in list
```

### Understanding Diagnostics
- Use `K` on an error to see full message
- Use `<Space>sd` to search all diagnostics

---

## Completion Tips

### Trigger Manually
Sometimes completion doesn't auto-trigger:
```
<C-Space>       → Force completion menu
```

### Navigate Docs
```
<C-b> / <C-f>   → Scroll documentation
K               → Full documentation popup
```

### Snippet Workflow
1. Type snippet trigger (e.g., `ge` in Go)
2. Select from completion menu
3. `<Tab>` to jump between placeholders
4. `<S-Tab>` to jump back

---

## Terminal Usage

### Quick Terminal
```
<c-`>           → Toggle floating terminal
<Esc><Esc>      → Exit terminal mode
,st             → Terminal at bottom of screen
```

### Run Commands
```
:GP             → Git pull
<leader>gg      → Lazygit (full TUI)
```

---

## Search & Replace

### Project-wide Search
```
<Space>sg       → Live grep
<Space>sw       → Grep word under cursor
```

### Search & Replace in File
```vim
:%s/old/new/gc          " With confirmation
:%s/old/new/g           " All occurrences
```

### Search & Replace in Selection
```
vaf             → Select a function (or vic, val, …)
:s/old/new/g    → Replace in selection
```

---

## LSP Tips

### Format on Save
Formatting happens automatically. To format manually:
```vim
:lua require('conform').format()
```

### Disable Formatting for File
Add to the file:
```lua
-- stylua: ignore
```

### Inlay Hints
Toggle with `<leader>uh` to see/hide type hints.

### C/C++: give clangd a compile database
Without one, clangd guesses your include paths and flags, so you get spurious
`'foo.h' file not found` errors on a project that compiles fine.

```bash
cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON    # CMake
bear -- make                                # Make (brew install bear)
```

For something small, a `compile_flags.txt` at the project root works too — one
flag per line (`-I./include`, `-std=c11`). Any of these also gives clangd a root
marker to anchor the project.

---

## Performance Tips

### Large Files
The `bigfile` module automatically disables heavy features for files >1.5MB.

### Slow Startup?
```vim
:Lazy profile     " See what's taking time
```

### LSP Issues?
```vim
:LspInfo          " Check attached servers
:LspRestart       " Restart servers
:LspLog           " View LSP logs
```

---

## Customization

### Add New LSP Server
Edit `lua/custom/plugins/lsp.lua`:
```lua
local servers = {
  your_server = true,  -- or { settings = {...} }
}
```

### Add New Snippet
Create file `lua/custom/snippets/LANG.lua`:
```lua
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("LANG", {
  s("trigger", fmt("template {}", { i(1) })),
})
```

### Add New Treesitter Parser
Parsers install automatically the first time you open a matching filetype. To
install one up front, add it to `ensure_installed` in
`lua/custom/plugins/treesitter.lua`, then `:TSInstall <lang>` (or restart).

Use `:checkhealth nvim-treesitter` to see what is installed and which queries
(highlight/indent/fold/injection) each parser has.

---

## Quick Reference Card

| Task | Keys |
|------|------|
| Find file | `<Space>sf` |
| Search text | `<Space>sg` |
| Go to definition | `gd` |
| Find references | `gr` |
| Rename | `<leader>cr` |
| Code action | `<Space>ca` |
| Next error | `]d` |
| Stage hunk | `<leader>hs` |
| Open Lazygit | `<leader>gg` |
| File explorer | `-` or `<leader>e` |
| Toggle terminal | `<c-\`>` |
| Ask opencode | `<leader>oa` |
