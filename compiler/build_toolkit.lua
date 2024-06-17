--
-- build_toolkit.lua
-- Retro Artist Toolkit
--
-- Created by Renan Maganha on June 11, 2024
--

local tool_list    = require("tool_list")
local Logger       = require("logger")
local date_manager = require("date_manager")
local file_manager = require("file_manager")
local file_cleaner = require("file_cleaner")

-------------------------------------------------------------------
-- FILE CLEANER
-------------------------------------------------------------------
local function addDocumentHeader(fileName)
    Logger:print(Logger.Weight.BOLD .. "[PROCESS] *** CREATING DOCUMENT HEADER ***", Logger.Colors.CYAN)

    local header = "--\n-- " .. fileName .. "\n-- Retro Artist Toolkit \n-- \n-- Created by Renan Maganha on ".. date_manager:getCurrentDate() .. "\n-- \n \n"

    Logger:print("[Success] header successfully created", Logger.Colors.GREEN)
    Logger:divider(Logger.Colors.CYAN)

    return header
end

local function addDependencyHeader(fileName)
    Logger:print("Adding header comment to dependency", Logger.Colors.CYAN)

    local header = string.rep("-", 67) .. "\n" .. "-- " .. string.upper(fileName) .. "\n" .. string.rep("-", 67) .. "\n" .. "\n"
    return header
end

local function extractFileName(filePath)
    return filePath:match("^.+/(.+)$")
end

-------------------------------------------------------------------
-- BUILD
-------------------------------------------------------------------
for _, tool in ipairs(tool_list) do
    Logger:printStepHeader("BUILDING: " .. tool.name, Logger.Colors.CYAN)

    Logger:print(Logger.Weight.BOLD .. "[PROCESS] *** READ THE MAIN FILE ***", Logger.Colors.CYAN)
    local main_script = file_manager:readFile(tool.path .. tool.name)
    main_script = file_cleaner:removeComments(main_script)
    main_script = file_cleaner:removeLocalRequires(main_script)

    local combined_dependecies = addDocumentHeader(tool.name)

    Logger:print(Logger.Weight.BOLD .. "[PROCESS] *** IMPORTING DEPENDENCIES ***", Logger.Colors.CYAN)

    if #tool.dependencies == 0 then
        Logger:print("There are no dependencies to import", Logger.Colors.CYAN)
    end

    for _, dependency in ipairs(tool.dependencies) do
        local dependency_name = extractFileName(dependency)

        Logger:print("Importing: " .. dependency_name, Logger.Colors.CYAN)

        local dependency_content = file_manager:readFile(dependency)

        combined_dependecies = combined_dependecies .. addDependencyHeader(dependency_name)

        Logger:print("Combining dependency into document", Logger.Colors.CYAN)

        combined_dependecies = combined_dependecies .. dependency_content

        Logger:print("[Success] the file was combined to the script", Logger.Colors.GREEN)

        Logger:divider(Logger.Colors.CYAN)
    end

    if #tool.dependencies ~= 0 then
        Logger:print("All dependencies were imported to the new script", Logger.Colors.GREEN)
        Logger:divider(Logger.Colors.CYAN)
    end

    Logger:print(Logger.Weight.BOLD .. "[PROCESS] *** COMBINING MAIN SCRIPT ***", Logger.Colors.CYAN)

    local combined_content = combined_dependecies .. "\n" .. addDependencyHeader(tool.name) .. main_script

    Logger:print("[Success] the main script was combined into the new script", Logger.Colors.GREEN)
    Logger:divider(Logger.Colors.CYAN)

    Logger:print(Logger.Weight.BOLD .. "[PROCESS] *** SAVING TOOL SCRIPT ***", Logger.Colors.CYAN)

    file_manager:writeFile("../retro_artist_toolkit/" .. tool.name, combined_content)
end

Logger:divider(Logger.Colors.CYAN)