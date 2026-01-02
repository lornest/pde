# Keymaps Reference

> **Leader Key:** `,` (comma)
> **Space** is used as a secondary leader for search and LSP operations

## Navigation

### Window Management

| Key | Action |
|-----|--------|
| `<C-h>` | Move to left split |
| `<C-j>` | Move to split below |
| `<C-k>` | Move to split above |
| `<C-l>` | Move to right split |

### Scrolling

| Key | Action |
|-----|--------|
| `<C-d>` | Half-page down (centered) |
| `<C-u>` | Half-page up (centered) |
| `n` | Next search result (centered) |
| `N` | Previous search result (centered) |
| `j` / `k` | Line navigation (respects wrap) |

### Flash (Enhanced Motions)

| Key | Mode | Action |
|-----|------|--------|
| `s` | n, x, o | Flash jump to character |
| `S` | n, x, o | Flash treesitter select |
| `r` | o | Remote flash (operator pending) |
| `R` | o, x | Treesitter search |
| `<C-s>` | c | Toggle flash in search |

## File Explorer (Oil)

| Key | Action |
|-----|--------|
| `-` | Open parent directory |
| `<leader>e` | Toggle float explorer |
| `<Space>-` | Toggle float explorer |
| `q` | Close explorer |
| `<M-h>` | Open in horizontal split |
| `<M-v>` | Open in vertical split |
| `<C-r>` | Refresh |

## Telescope (Fuzzy Finding)

### File Search

| Key | Action |
|-----|--------|
| `<Space>sf` | Find files |
| `<Space>sg` | Live grep |
| `<Space>sw` | Grep current word |
| `<Space>s.` | Recent files |
| `<Space>sn` | Search neovim config |

### Navigation

| Key | Action |
|-----|--------|
| `<Space><Space>` | Find buffers |
| `<Space>/` | Fuzzy search current buffer |
| `<Space>s/` | Grep in open files |
| `<Space>sr` | Resume last search |

### Help & Discovery

| Key | Action |
|-----|--------|
| `<Space>sh` | Help tags |
| `<Space>sk` | Keymaps |
| `<Space>ss` | Telescope builtins |
| `<Space>sd` | Diagnostics |

## LSP (Language Server)

### Navigation

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gr` | Go to references |
| `gD` | Go to declaration |
| `gT` | Go to type definition |
| `gI` | Go to implementation |

### Documentation

| Key | Action |
|-----|--------|
| `K` | Hover documentation |
| `<C-k>` | Signature help |

### Actions

| Key | Action |
|-----|--------|
| `<Space>cr` | Rename symbol (with preview) |
| `<Space>ca` | Code actions (with preview) |
| `<Space>wd` | Document symbols |
| `<Space>ws` | Workspace symbols |

### Diagnostics

| Key | Action |
|-----|--------|
| `<leader>l` | Toggle lsp_lines display |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |

## Trouble (Diagnostics List)

| Key | Action |
|-----|--------|
| `<leader>xx` | Toggle diagnostics |
| `<leader>xX` | Toggle buffer diagnostics |
| `<leader>cs` | Toggle symbols |
| `<leader>cS` | Toggle LSP references |
| `<leader>xL` | Toggle location list |
| `<leader>xQ` | Toggle quickfix list |
| `[q` | Previous quickfix item |
| `]q` | Next quickfix item |

## Git

### Gitsigns (Hunks)

| Key | Action |
|-----|--------|
| `]h` | Next hunk |
| `[h` | Previous hunk |
| `<leader>hs` | Stage hunk |
| `<leader>hr` | Reset hunk |
| `<leader>hS` | Stage buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hR` | Reset buffer |
| `<leader>hp` | Preview hunk |
| `<leader>hb` | Blame line (full) |
| `<leader>hB` | Toggle line blame |
| `<leader>hd` | Diff this |
| `<leader>hD` | Diff this ~ |
| `ih` | (text object) Select hunk |

### Snacks Git Integration

| Key | Action |
|-----|--------|
| `<leader>gg` | Open Lazygit |
| `<leader>gl` | Lazygit log |
| `<leader>gf` | Lazygit file history |
| `<leader>gb` | Blame line |
| `<leader>gB` | Git browse (open in browser) |

## Treesitter

### Incremental Selection

| Key | Action |
|-----|--------|
| `<C-Space>` | Start/expand selection |
| `<BS>` | Shrink selection |

### Text Objects

| Key | Action |
|-----|--------|
| `af` / `if` | Around/inner function |
| `ac` / `ic` | Around/inner class |
| `aa` / `ia` | Around/inner argument |
| `ai` / `ii` | Around/inner conditional |
| `al` / `il` | Around/inner loop |

### Movement

| Key | Action |
|-----|--------|
| `]f` / `[f` | Next/prev function start |
| `]F` / `[F` | Next/prev function end |
| `]c` / `[c` | Next/prev class start |
| `]C` / `[C` | Next/prev class end |
| `]a` / `[a` | Next/prev argument |

### Swap

| Key | Action |
|-----|--------|
| `<leader>a` | Swap argument with next |
| `<leader>A` | Swap argument with previous |

## Completion (nvim-cmp)

| Key | Mode | Action |
|-----|------|--------|
| `<C-n>` | i | Next item |
| `<C-p>` | i | Previous item |
| `<C-y>` | i, c | Confirm selection |
| `<CR>` | i | Confirm (if selected) |
| `<C-e>` | i | Abort completion |
| `<C-Space>` | i | Trigger completion |
| `<C-b>` | i | Scroll docs up |
| `<C-f>` | i | Scroll docs down |

### Snippets

| Key | Mode | Action |
|-----|------|--------|
| `<Tab>` | i, s | Jump to next placeholder |
| `<S-Tab>` | i, s | Jump to previous placeholder |

## Debugging (DAP)

| Key | Action |
|-----|--------|
| `<Space>b` | Toggle breakpoint |
| `<Space>rb` | Run to cursor |
| `<Space>?` | Eval expression under cursor |
| `F1` | Continue |
| `F2` | Step into |
| `F3` | Step over |
| `F4` | Step out |
| `F5` | Step back |
| `F13` | Restart |

## Snacks Utilities

### Buffers & Windows

| Key | Action |
|-----|--------|
| `<leader>bd` | Delete buffer |
| `<leader>z` | Toggle zen mode |
| `<leader>Z` | Toggle zoom |
| `<c-\`>` | Toggle terminal |

### Scratch & Notes

| Key | Action |
|-----|--------|
| `<leader>.` | Toggle scratch buffer |
| `<leader>S` | Select scratch buffer |

### Notifications

| Key | Action |
|-----|--------|
| `<leader>n` | Show notification history |
| `<leader>un` | Dismiss all notifications |

### Navigation

| Key | Action |
|-----|--------|
| `]]` | Next reference |
| `[[` | Previous reference |

### File Operations

| Key | Action |
|-----|--------|
| `<leader>cR` | Rename file |
| `<leader>N` | Open Neovim news |

## Toggles (Snacks)

| Key | Action |
|-----|--------|
| `<leader>us` | Toggle spelling |
| `<leader>uw` | Toggle word wrap |
| `<leader>uL` | Toggle relative numbers |
| `<leader>ud` | Toggle diagnostics |
| `<leader>ul` | Toggle line numbers |
| `<leader>uh` | Toggle inlay hints |
| `<leader>ug` | Toggle indent guides |
| `<leader>uD` | Toggle dim mode |
| `<leader>ub` | Toggle dark/light background |
| `<leader>uT` | Toggle treesitter |
| `<leader>uc` | Toggle conceal |

## Sessions (Persistence)

| Key | Action |
|-----|--------|
| `<leader>qs` | Restore session |
| `<leader>qS` | Select session |
| `<leader>ql` | Restore last session |
| `<leader>qd` | Don't save current session |

## Mini.nvim

### Surround

| Key | Action |
|-----|--------|
| `sa` | Add surrounding |
| `sd` | Delete surrounding |
| `sr` | Replace surrounding |

### Split/Join

| Key | Action |
|-----|--------|
| `gS` | Toggle split/join |

## Which-Key

| Key | Action |
|-----|--------|
| `<leader>?` | Show buffer-local keymaps |
| (wait) | Any prefix shows available keys |

## Miscellaneous

| Key | Action |
|-----|--------|
| `:GP` | Git pull (custom command) |
| `<leader>p` | Paste without yanking (visual) |
| `<Esc><Esc>` | Exit terminal mode |
| `,st` | Open terminal at bottom |
