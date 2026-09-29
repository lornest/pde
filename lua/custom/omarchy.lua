--[[
-- Omarchy theme integration
--
-- Omarchy writes the active theme's lazy.nvim spec to
-- ~/.local/state/omarchy/current/theme/neovim.lua. The spec is written for
-- LazyVim: one or more colorscheme plugins, plus a "LazyVim/LazyVim" entry
-- whose `opts.colorscheme` names the colorscheme to apply. This module reads
-- that spec without LazyVim, applies it, and follows `omarchy theme set` live.
--
-- On machines without Omarchy, `enabled` is false and nothing here runs, so
-- `custom/plugins/colorscheme.lua` picks the theme instead.
--]]
local M = {}

local omarchy_path = vim.env.OMARCHY_PATH or "/usr/share/omarchy"
local state_dir = vim.env.HOME .. "/.local/state/omarchy/current"

M.theme_file = state_dir .. "/theme/neovim.lua"
M.enabled = vim.uv.fs_stat(M.theme_file) ~= nil

-- Highlight groups Omarchy makes transparent, so the terminal background shows through
local transparent_groups = {
  "Normal",
  "NormalFloat",
  "NormalNC",
  "FloatBorder",
  "Pmenu",
  "Terminal",
  "EndOfBuffer",
  "FoldColumn",
  "Folded",
  "SignColumn",
  "LineNr",
  "CursorLineNr",
  "WhichKeyFloat",
  "TelescopeBorder",
  "TelescopeNormal",
  "TelescopePromptBorder",
  "TelescopePromptTitle",
}

local function plugin_name(entry)
  return entry.name or entry[1]:match "[^/]+$"
end

--- Read an Omarchy theme spec into { colorscheme = string, plugins = { spec, ... } }
local function read_spec(file)
  local ok, spec = pcall(dofile, file)
  if not ok or type(spec) ~= "table" then
    return nil
  end

  local theme = { plugins = {} }
  for _, entry in ipairs(spec) do
    if type(entry) == "string" then
      entry = { entry }
    end
    if type(entry) == "table" and type(entry[1]) == "string" then
      if entry[1] == "LazyVim/LazyVim" then
        theme.colorscheme = entry.opts and entry.opts.colorscheme
      else
        table.insert(theme.plugins, entry)
      end
    end
  end

  if type(theme.colorscheme) ~= "string" then
    return nil
  end
  return theme
end

--- Add a plugin (and its dependencies) to `catalog`, keyed by url.
--- Only the fields that identify the plugin are kept, so specs from different
--- themes never merge their `opts` into each other.
local function add_to_catalog(catalog, entry)
  if type(entry) == "string" then
    entry = { entry }
  end
  local url = entry[1]
  if type(url) ~= "string" then
    return
  end

  local plugin = catalog[url] or { url, lazy = true, priority = 1000 }
  plugin.name = plugin.name or entry.name
  plugin.branch = plugin.branch or entry.branch
  catalog[url] = plugin

  for _, dep in ipairs(entry.dependencies or {}) do
    add_to_catalog(catalog, dep)
  end
end

--- lazy.nvim specs: every theme plugin Omarchy ships (lazy, so switching
--- themes never needs a download), with the active theme loaded at startup.
---
--- User themes in ~/.config/omarchy/themes are deliberately not scanned:
--- themes installed from git can ship arbitrary Lua, which Omarchy itself
--- refuses to run. Their plugins are picked up once they are the active theme.
function M.specs()
  local catalog = {}
  local files = vim.fn.glob(omarchy_path .. "/themes/*/neovim.lua", false, true)
  table.insert(files, omarchy_path .. "/default/themed/neovim.lua.tpl")

  for _, file in ipairs(files) do
    local theme = read_spec(file)
    for _, entry in ipairs(theme and theme.plugins or {}) do
      add_to_catalog(catalog, entry)
    end
  end

  local current = read_spec(M.theme_file)
  for _, entry in ipairs(current and current.plugins or {}) do
    add_to_catalog(catalog, entry)
  end

  -- The active theme keeps its `opts`, so lazy passes them to setup()
  for _, entry in ipairs(current and current.plugins or {}) do
    local plugin = vim.deepcopy(entry)
    plugin.name = catalog[entry[1]].name
    plugin.branch = catalog[entry[1]].branch
    plugin.dependencies = nil
    plugin.lazy = false
    plugin.priority = 1000
    catalog[entry[1]] = plugin
  end

  return vim.tbl_values(catalog)
end

local function make_transparent()
  for _, name in ipairs(transparent_groups) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name, link = false })
    if ok then
      hl.bg = nil
      vim.api.nvim_set_hl(0, name, hl)
    end
  end
end

local function apply(theme)
  vim.cmd "highlight clear"
  -- Light themes set this back to "light" themselves
  vim.o.background = "dark"

  local ok, err = pcall(vim.cmd.colorscheme, theme.colorscheme)
  if not ok then
    vim.notify("omarchy: could not apply colorscheme " .. theme.colorscheme .. "\n" .. err, vim.log.levels.WARN)
  end
end

--- Re-read the theme spec after `omarchy theme set` and apply it
local function reload()
  local theme = read_spec(M.theme_file)
  if not theme then
    return
  end

  local plugins = require("lazy.core.config").plugins
  for _, entry in ipairs(theme.plugins) do
    local plugin = plugins[plugin_name(entry)]
    if not plugin then
      vim.notify("omarchy: restart Neovim to install " .. entry[1], vim.log.levels.WARN)
      return
    end

    -- Themes that share a plugin differ only in `opts` (e.g. catppuccin and
    -- catppuccin-latte), so rerun setup() on a fresh copy of the plugin's
    -- modules to drop the opts the previous theme left behind
    if entry.opts or plugin._.loaded then
      if plugin._.loaded then
        require("lazy.core.util").walkmods(plugin.dir .. "/lua", function(modname)
          package.loaded[modname] = nil
        end)
      end
      require("lazy").load { plugins = { plugin.name } }

      local main = require("lazy.core.loader").get_main(plugin)
      local ok, mod = pcall(require, main)
      if ok and type(mod) == "table" and mod.setup then
        pcall(mod.setup, entry.opts or {})
      end
    end
  end

  apply(theme)
end

local function watch()
  local watcher = vim.uv.new_fs_event()
  local debounce = vim.uv.new_timer()
  if not watcher or not debounce then
    return
  end

  -- `omarchy theme set` swaps the theme directory, then writes theme.name
  watcher:start(state_dir, {}, function(err, filename)
    if err or filename ~= "theme.name" then
      return
    end
    debounce:stop()
    debounce:start(100, 0, vim.schedule_wrap(reload))
  end)
end

--- Apply the active Omarchy theme and follow theme changes. Call after lazy.setup().
function M.setup()
  if not M.enabled then
    return
  end

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("custom-omarchy", { clear = true }),
    callback = make_transparent,
  })

  local theme = read_spec(M.theme_file)
  if theme then
    apply(theme)
  else
    vim.notify("omarchy: could not read " .. M.theme_file, vim.log.levels.WARN)
  end

  watch()
end

return M
