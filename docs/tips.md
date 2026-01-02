# Tips & Workflows

## Getting Started

### First Launch Checklist
```vim
:Lazy sync              " Install all plugins
:TSUpdate               " Install treesitter parsers  
:MasonToolsInstall      " Install LSP servers and tools
:checkhealth            " Verify everything is working
```

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

### Flash Jump (Fastest Navigation)
1. Press `s`
2. Type 1-2 characters you want to jump to
3. Press the highlighted label

**Pro tip:** Use `S` to select treesitter nodes (great for selecting functions/blocks).

### File Explorer
- `-` from any buffer opens the parent directory
- Edit filenames like a buffer, then save to rename
- Use `d` to delete, create new files by typing names

---

## Code Editing

### Rename Symbol Everywhere
1. Place cursor on symbol
2. Press `<Space>cr`
3. Type new name (see preview)
4. Press `<CR>` to confirm

### Code Actions
1. On a diagnostic or code location
2. Press `<Space>ca`
3. Preview the action in Telescope
4. Press `<CR>` to apply

### Multi-cursor Alternative
Use treesitter selection + substitute:
```
<C-Space>   → Start selection at cursor
<C-Space>   → Expand to parent node
:s/old/new/ → Substitute in selection
```

### Surround Operations
```
saiw"   → Add " around word
sd"     → Delete surrounding "
sr"'    → Replace " with '
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

## Debugging (Go)

### Basic Debug Session
1. Set breakpoint: `<Space>b`
2. Start debugging: `:DapContinue` or `F1`
3. Step through: `F2` (into), `F3` (over), `F4` (out)
4. Inspect variable: `<Space>?`

### Debug Current Test
```vim
:lua require('dap-go').debug_test()
```

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
<C-Space>       → Select code block
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
Edit `lua/custom/plugins/treesitter.lua`, add to `ensure_installed`.

---

## Quick Reference Card

| Task | Keys |
|------|------|
| Find file | `<Space>sf` |
| Search text | `<Space>sg` |
| Go to definition | `gd` |
| Find references | `gr` |
| Rename | `<Space>cr` |
| Code action | `<Space>ca` |
| Next error | `]d` |
| Stage hunk | `<leader>hs` |
| Open Lazygit | `<leader>gg` |
| File explorer | `-` or `<leader>e` |
| Toggle terminal | `<c-\`>` |
| Flash jump | `s` |
