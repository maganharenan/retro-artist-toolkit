local Logger = require("logger")
local lfs = require("lfs")

local file_manager = {}

-------------------------------------------------------------------
-- HELPER METHODS
-------------------------------------------------------------------
local function createPath(path)
    Logger:print("Creating directory at path: " .. path, Logger.Colors.CYAN)

    os.execute("mkdir " .. "../retro_artist_toolkit")

    Logger:print("[Success] Path was successfully created", Logger.Colors.GREEN)
end

-------------------------------------------------------------------
-- MAIN METHODS
-------------------------------------------------------------------
function file_manager:readFile(path)
    Logger:print("Trying to open file at path: " .. path, Logger.Colors.CYAN)

    local file = io.open(path, "r")

    if not file then
        Logger:print("[ERROR] Unable to open: " .. path, Logger.Colors.RED)
        Logger:divider(Logger.Colors.CYAN)
        return nil
    end

    local content = file:read("*all")
    file:close()

    if not content then
        Logger:print("[ERROR] No content was found when reading: " .. path, Logger.Colors.RED)
        Logger:divider(Logger.Colors.CYAN)
        return nil
    end

    Logger:print("[Success] file was read successfully", Logger.Colors.GREEN)
    Logger:divider(Logger.Colors.CYAN)

    return content
end

function file_manager:writeFile(path, content)
    local separatedPath = path:match("^(.*[/\\])")

    Logger:print("Trying to find directory at path: " .. separatedPath, Logger.Colors.CYAN)
    local directory = path:match("^(.*" .. separatedPath .. ")")
    
    if not lfs.attributes(directory, "mode") then
        createPath(separatedPath)
    end

    Logger:print("Trying to open directory at path: " .. separatedPath, Logger.Colors.CYAN)
    local file = io.open(path, "w")
    if file then
        Logger:print("Writing the file", Logger.Colors.CYAN)

        file:write(content)
        file:close()
    else
        Logger:print("Failed to open directory: " .. path, Logger.Colors.RED)
    end

    Logger:print("[Success] File was successfully writed", Logger.Colors.GREEN)
end

return file_manager