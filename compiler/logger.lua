local date_manager = require("date_manager")

Logger = {

    Weight = {
        BOLD = "\27[1m"
    },

    Colors = {
        RED = "\27[31m",
        GREEN = "\27[32m",
        YELLOW = "\27[33m",
        ORANGE = "\27[38;5;208m",
        CYAN = "\27[36m",
        MAGENTA = "\27[35m",
        LIGHT_PURPLE = "\27[95m",
        RESET = "\27[0m"
    }

}

local headerLength = 80

-------------------------------------------------------------------
-- HELPER METHODS
-------------------------------------------------------------------
local function centralizeTextInHeader(text)
    local centralizedText = ""

    local totalHyphens = 4
    local charactersRemaining = headerLength - #text - totalHyphens
    local divisibleByTwo = true
    local spaceToSet = 0

    if charactersRemaining % 2 ~= 0 then
        divisibleByTwo = false
        spaceToSet = (charactersRemaining + 1) / 2
    else
        spaceToSet = charactersRemaining / 2
    end

    centralizedText = centralizedText .. string.rep("-", totalHyphens / 2)
    centralizedText = centralizedText .. string.rep(" ", spaceToSet)
    centralizedText = centralizedText .. string.upper(text)
    
    if divisibleByTwo then
        centralizedText = centralizedText .. string.rep(" ", spaceToSet)
    else
        centralizedText = centralizedText .. string.rep(" ", spaceToSet - 1)
    end

    centralizedText = centralizedText .. string.rep("-", totalHyphens / 2)

    return centralizedText
end

-------------------------------------------------------------------
-- MAIN METHODS
-------------------------------------------------------------------
function Logger:printStepHeader(text, color) 
    local header = string.rep("-", headerLength) .. "\n" .. centralizeTextInHeader(text) .. "\n" .. string.rep("-", headerLength)
    
    print(color .. header .. Logger.Colors.RESET)
end

function Logger:print(text, color) 
    print(color .. "-- " .. text .. Logger.Colors.RESET)
end

function Logger:divider(color)
    print(color .. string.rep("-", headerLength) .. Logger.Colors.RESET)
end

Logger:printStepHeader("build toolkit", Logger.Colors.CYAN)
Logger:print("Version: 1.0", Logger.Colors.CYAN)
Logger:print("Date: " .. date_manager:getCurrentDate(), Logger.Colors.CYAN)
Logger:print("Copyright (c) 2023 Renan Maganha", Logger.Colors.CYAN)
Logger:print("Description: Tool for automated builds", Logger.Colors.CYAN)
Logger:divider(Logger.Colors.CYAN)

return Logger