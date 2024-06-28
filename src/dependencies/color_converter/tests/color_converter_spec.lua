-- tests/color_converter_spec.lua
-- navigate to the dependecy folder and run: `busted --pattern=_spec tests`

local color_converter = require("src.color_converter")

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

describe("Palette Generator Test", function()

    it ("Should split the hex value into an array of String", function()
        local expected = { "C0", "78", "B8" }
        local passed = color_converter.SplitHexIntoPairs("C078B8")

        assert.same(passed, expected)
    end)

    it ("Shoud convert hex to binary", function ()
        local expected = "11000000"
        local passed = color_converter.HexToBinary("C0")

        assert.same(passed, expected)
    end)

    it ("Should convert all hex pairs to binaries", function ()
        local expected = {"11000000", "01111000", "10111000"}
        local passed = color_converter.GetBinaries({"C0", "78", "B8"})

        assert.same(passed, expected)
    end)

    it ("Should discard not relevant bites", function ()
        local expected = "11000"
        local passed = color_converter.GetRelevantBits("11000000")

        assert.same(passed, expected)
    end)

    it ("Should get BGR555 binary", function ()
        local binaries = color_converter.GetBinaries({"C0", "78", "B8"})

        local expected = "0101110111111000"
        local passed = color_converter.GetBGR555Binary(binaries)

        assert.same(passed, expected)
    end)

    it ("Should turn a binary into a hex", function ()
        local expected = "5DF8"
        local passed = color_converter.GetBGR555Hex("0101110111111000")

        assert.same(passed, expected)
    end)

    it ("Should reverse lowest and highest bite ", function ()
        local expected = "F85D"
        local passed = color_converter.GetReverseHexBytes("5DF8")

        assert.same(passed, expected)
    end)

    it ("Should generate a String with the reversed bites of all BGR555 colors in the palette", function ()
        local colors = {
            "7f7f7f", "f0c8e8", "c078b8", "784090", "f8f8f8", "c0f8d8", "50e0d0", "4890c0", 
            "205870", "003858", "001830", "c02008", "f8a018", "f04980", "600800", "000000" 
        }

        local expected = "EF3D3E77F85D0F49FF7FF86F8A6B49626439E02C601898049F0E3E412C000000"
        local passed = color_converter.GetPaletteHex(colors)

        assert.same(passed, expected)
    end)

    it ("Should convert hex string to binary", function ()
        local hex = "EF3D3E77F85D0F49FF7FF86F8A6B49626439E02C601898049F0E3E412C000000"

        local expected = "�=>w�]�I���o�kIbd9�,`���>A,���"
        local passed = hexToBinary(hex)

        assert.same(passed, expected)
    end)

end)