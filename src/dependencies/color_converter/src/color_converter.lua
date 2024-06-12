--
-- tool.lua
-- Retro Artist Toolkit
--
-- Created by Renan Maganha on June 11, 2024
--

local color_converter = {}

function color_converter.LeftPadding(str, toLength, character)
    local newLength = #str
    local padding = ""
    
    if newLength < toLength then
        padding = string.rep(character, toLength - newLength)
    end

    return padding .. str
end

function color_converter.SplitHexIntoPairs(hexString)
    local pairs = {}

    for index = 1, #hexString, 2 do
        local pair = hexString:sub(index, index + 1)
        table.insert(pairs, pair)
    end

    return pairs
end

function color_converter.GetRelevantBits(inputString)
    local endIndex = 5

    return string.sub(inputString, 1, endIndex)
end

function color_converter.HexToBinary(hexValue)
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

function color_converter.GetBinaries(hexPairs)
    local binaryStrings = {}

    for _, hexPair in ipairs(hexPairs) do
        table.insert(binaryStrings, color_converter.HexToBinary(hexPair))
    end

    return binaryStrings
end

function color_converter.GetBGR555Binary(binaries)
    local BGR555Binary = "0"
    
    for index = #binaries, 1, -1 do
        BGR555Binary = BGR555Binary .. color_converter.GetRelevantBits(binaries[index])
    end
    
    return BGR555Binary
end

function color_converter.GetBGR555Hex(binaryString)
    local binaryValue = tonumber(binaryString, 2)
    
    if not binaryValue then
        print("Invalid binary string")
        return nil
    end
    
    local hexString = string.format("%04X", binaryValue)
    
    return string.upper(hexString)
end

function color_converter.GetReverseHexBytes(hex)
    local hexPairs = color_converter.SplitHexIntoPairs(hex)

    return hexPairs[#hexPairs] .. hexPairs[1]
end

function color_converter.GetPaletteHex(colors)
    local paletteHex = ""

    for _, color in ipairs(colors) do
        local hexPairs = color_converter.SplitHexIntoPairs(color)
        local binaries = {}
        for _, pair in ipairs(hexPairs) do
            table.insert(binaries, color_converter.HexToBinary(pair))
        end
        local BGR555Binary = color_converter.GetBGR555Binary(binaries)
        local BGR555Hex = color_converter.GetBGR555Hex(BGR555Binary)
        local reversedHex = color_converter.GetReverseHexBytes(BGR555Hex)

        paletteHex = paletteHex .. reversedHex
    end

    return paletteHex
end

return color_converter