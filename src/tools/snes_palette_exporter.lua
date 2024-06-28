local dialogBox = Dialog("SNES PALETTE EXPORTER")

local color_converter = require("src.color_converter")

local sprite = app.sprite
local shades = {}

local errors = {
    noSprite = "There is no sprite open",
    colorMode = "Sprite color mode must be indexed",
    width = "Sprite width needs to be a multiple of 8",
    height = "Sprite height needs to be a multiple of 8"
}

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

local function hexToBinary(hexString)
    local binaryString = ""
    for i = 1, #hexString, 2 do
        local hexPair = hexString:sub(i, i + 1)
        local byte = tonumber(hexPair, 16)
        if byte then
            binaryString = binaryString .. string.char(byte)
        else
            return nil, "Invalid hex character detected"
        end
    end
    return binaryString
end

local function showError(message)
    app.alert{title="Error", text=message, buttons="OK"}
end

local function isSpriteValid()
    if not sprite then
        showError(errors.noSprite)
        return false
    end

    if sprite.colorMode ~= ColorMode.INDEXED then
        showError(errors.colorMode)
        return false
    end

    if (sprite.width % 8) ~= 0 then
        showError(errors.width)
        return false
    end

    if (sprite.height % 8) ~= 0 then
        showError(errors.height)
        return false
    end

    return true
end

-------------------------------------------------------------------
-- METHODS
-------------------------------------------------------------------
local function exportPalette()
    if not isSpriteValid() then
		return
	end

    local currentPalette = getHexadecimalPalette()
    local paletteHex = color_converter.GetPaletteHex(currentPalette)
    local binaryPalette = hexToBinary(paletteHex)

    local out = io.open(app.fs.normalizePath(dialogBox.data.exportpal), "wb")
	out:write(binaryPalette)
	out:close()

    dialogBox:modify{
		id="exportpal",
		filename = "newPalette"}
        dialogBox.bounds = dialogBox.bounds

	app.refresh()
end

function populatePalette()
    for _i = 0, #sprite.palettes[1] - 1 do
        local color = sprite.palettes[1]:getColor(_i)
        table.insert(shades, color)
    end
end

-------------------------------------------------------------------
-- USER INTERFACE
-------------------------------------------------------------------
function ShowMain()
    dialogBox: shades {
        id = 'shades', 
        colors = shades,
    }
    
    :newrow()
    
    dialogBox: separator {
        text = "Export"
    }
    
    dialogBox: file {
        id = "exportpal",
        title = "Export the palette",
        save = true,
        filename = "palette",
        filetypes = { "pal", "txt" },
        onchange = exportPalette
    }
    
    dialogBox: show { wait = false }
end

do
    populatePalette()
    ShowMain()
end
