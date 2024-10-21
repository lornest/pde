local opt = vim.opt

--- Show incremental command preview
opt.inccommand = "split"

--- Search settings
opt.smartcase = true
opt.ignorecase = true
opt.hlsearch = false

-- Make line numbers default
opt.number = true
opt.relativenumber = true

-- Enable mouse mode
opt.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
opt.clipboard = "unnamedplus"

-- Enable break indent
opt.breakindent = true

-- Save undo history
opt.undofile = true

-- Keep signcolumn on by default
opt.signcolumn = "yes"

-- Customise the amount of Shared Data stored
opt.shada = { "'10", "<0", "s10", "h" }

-- Decrease update time
opt.updatetime = 250
opt.timeoutlen = 300

opt.wrap = true
opt.linebreak = true

opt.tabstop = 2
opt.shiftwidth = 2

opt.more = false

-- Set completeopt to have a better completion experience
opt.completeopt = "menuone,noselect"

-- NOTE: You should make sure your terminal supports this
opt.termguicolors = true
