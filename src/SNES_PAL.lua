-- src/SNES_PAL.lua
local dialogBox = Dialog("SNES PALETTE EXPORTER")
local snesPaletteModule = {}
-------------------------------------------------------------------
-- HELPER METHODS
-------------------------------------------------------------------
function snesPaletteModule.LeftPadding(str, toLength, character)
    local newLength = #str
    local padding = ""
    
    if newLength < toLength then
        padding = string.rep(character, toLength - newLength)
    end

    return padding .. str
end

function snesPaletteModule.SplitHexIntoPairs(hexString)
    local pairs = {}

    for index = 1, #hexString, 2 do
        local pair = hexString:sub(index, index + 1)
        table.insert(pairs, pair)
    end

    return pairs
end

function snesPaletteModule.GetRelevantBits(inputString)
    local endIndex = 5

    return string.sub(inputString, 1, endIndex)
end

function snesPaletteModule.HexToBinary(hexValue)
    local function toBinary(hexChar)
        local binaryString = ""
        for i = 3, 0, -1 do
            local bitValue = 2^i
            if hexChar >= bitValue then
                binaryString = binaryString .. "1"
                hexChar = hexChar - bitValue
            else
                binaryString = binaryString .. "0"
            end
        end
        return binaryString
    end

    local binaryString = ""
    for i = 1, #hexValue do
        local hexChar = tonumber(hexValue:sub(i, i), 16) or 0
        binaryString = binaryString .. toBinary(hexChar)
    end

    return binaryString
end

function snesPaletteModule.GetBinaries(hexPairs)
    local binaryStrings = {}

    for _, hexPair in ipairs(hexPairs) do
        table.insert(binaryStrings, snesPaletteModule.HexToBinary(hexPair))
    end

    return binaryStrings
end

function snesPaletteModule.GetBGR555Binary(binaries)
    local BGR555Binary = "0"
    
    for index = #binaries, 1, -1 do
        BGR555Binary = BGR555Binary .. snesPaletteModule.GetRelevantBits(binaries[index])
    end
    
    return BGR555Binary
end

function snesPaletteModule.GetBGR555Hex(binaryString)
    local binaryValue = tonumber(binaryString, 2)
    
    if not binaryValue then
        print("Invalid binary string")
        return nil
    end
    
    local hexString = string.format("%04X", binaryValue)
    
    return string.upper(hexString)
end

function snesPaletteModule.GetReverseHexBytes(hex)
    local hexPairs = snesPaletteModule.SplitHexIntoPairs(hex)

    return hexPairs[#hexPairs] .. hexPairs[1]
end

function snesPaletteModule.GetPaletteHex(colors)
    local paletteHex = ""

    for _, color in ipairs(colors) do
        local hexPairs = snesPaletteModule.SplitHexIntoPairs(color)
        local binaries = {}
        for _, pair in ipairs(hexPairs) do
            table.insert(binaries, snesPaletteModule.HexToBinary(pair))
        end
        local BGR555Binary = snesPaletteModule.GetBGR555Binary(binaries)
        local BGR555Hex = snesPaletteModule.GetBGR555Hex(BGR555Binary)
        local reversedHex = snesPaletteModule.GetReverseHexBytes(BGR555Hex)

        paletteHex = paletteHex .. reversedHex
    end

    return paletteHex
end

-------------------------------------------------------------------
-- LOCAL METHODS
-------------------------------------------------------------------
local function exportPalette()
    local currentPalette = getHexadecimalPalette
    local getPaletteHex = getPaletteHex(currentPalette)

    local out = io.open(app.fs.normalizePath(dialogBox.data.exportpal), "wb")
	out:write(getPaletteHex)
	out:close()

    dialogBox:modify{
		id="exportpal",
		filename = "newPalette"}
        dialogBox.bounds = dialogBox.bounds

	app.refresh()
end

return snesPaletteModule