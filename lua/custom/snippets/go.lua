require("luasnip.session.snippet_collection").clear_snippets "go"

-- Require LuaSnip and related modules
local ls = require "luasnip"
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

-- Add Go snippets
ls.add_snippets("go", {
  s("ge", fmt("if err != nil {{\n\t{}\n}}", { i(0, "return err") })),
})
