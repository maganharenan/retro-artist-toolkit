local snesPaletteModule = require("src.SNES_PAL")

local sprite = app.sprite
local shade_pal = {}

-------------------------------------------------------------------
-- HELPER METHODS
-------------------------------------------------------------------
local function getHexadecimalPalette()
    local currentPalette = sprite.palettes[1]

    local colorAmount = math.min(#currentPalette, 256)
    local colors = {}

    for index = 1, 256 do
        if index <= colorAmount then
            local color = currentPalette:getColor(index - 1)
            colors[index] = string.format("%02X%02X%02X", color.red, color.green, color.blue) 
        end
    end

    return colors
end

-------------------------------------------------------------------
-- LOCAL METHODS
-------------------------------------------------------------------
local function exportPalette()
    local currentPalette = getHexadecimalPalette()
    local getPaletteHex = snesPaletteModule.GetPaletteHex(currentPalette)

    local out = io.open(app.fs.normalizePath(dialogBox.data.exportpal), "wb")
	out:write(getPaletteHex)
	out:close()

    dialogBox:modify{
		id="exportpal",
		filename = "newPalette"}
        dialogBox.bounds = dialogBox.bounds

	app.refresh()
end

function populatePalette()
    for _i = 1, #sprite.palettes[1] - 1 do
        local c = sprite.palettes[1]:getColor(_i)
        table.insert(shade_pal, c)
    end
end

-------------------------------------------------------------------
-- USER INTERFACE
-------------------------------------------------------------------
function ShowMain()
    dialogBox: shades {
        id = 'sha', 
        colors = shade_pal,
    }
    
    :newrow()
    
    dialogBox: separator {
        text = "Export"
    }
    
    dialogBox: file{
        id = "exportpal",
        title = "Export a palette",
        save = true,
        filename = "Export 4BPP Palette",
        filetypes = { "pal", "txt" },
        onchange = exportPalette
    }
    
    dialogBox: show { wait = false }
end

do
    populatePalette()
    ShowMain()
end
