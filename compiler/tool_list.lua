--
-- tool_list.lua
-- Retro Artist Toolkit
--
-- Created by Renan Maganha on June 11, 2024
--

local Tool = require("tool")

Tools_list = {}

-------------------------------------------------------------------
-- SNES PALETTE EXPORTER
-------------------------------------------------------------------
local snes_palette_exporter = Tool:new(
    "snes_palette_exporter.lua",
    "../src/tools/",
    {
        "../src/dependencies/color_converter/src/color_converter.lua"
    }
)

table.insert(Tools_list, snes_palette_exporter)

return Tools_list