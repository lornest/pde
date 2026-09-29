-- Theme plugins for Omarchy's theme switcher. Empty when Omarchy isn't installed.
local omarchy = require "custom.omarchy"

if not omarchy.enabled then
  return {}
end

return omarchy.specs()
