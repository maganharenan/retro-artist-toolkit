--
-- build_toolkit.lua
-- Retro Artist Toolkit
--
-- Created by Renan Maganha on June 11, 2024
--

local tool_list = require("tool_list")

-------------------------------------------------------------------
-- FILE CLEANER
-------------------------------------------------------------------

local function getCurrentDate()
    local currentDate = os.date("*t")
    local monthNames = {
        "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"
    }
    local monthName = monthNames[currentDate.month]
    local formattedDate = string.format("%s %d, %d", monthName, currentDate.day, currentDate.year)
    return formattedDate
end

local function removeComments(content)
    local lines = {}
    for line in content:gmatch("(.-)\n") do
        if not line:match("^%s*%-%-") then
            table.insert(lines, line)
        end
    end
    return table.concat(lines, "\n")
end

local function removeReturnLines(content)
    local lines = {}
    local wordsToRemove = { "local", "require" }

    for line in content:gmatch("[^\r\n]+") do
        for _, word in ipairs(wordsToRemove) do
            if not line:find(word) then
                table.insert(lines, line)
                break
            end
        end
    end

    return table.concat(lines, "\n")
end

local function addDocumentHeader(fileName)
    local header = "--\n-- " .. fileName .. "\n-- Retro Artist Toolkit \n-- \n-- Created by Renan Maganha on ".. getCurrentDate() .. "\n-- \n \n"
    return header
end

local function addDependencyHeader(fileName)
    local header = string.rep("-", 67) .. "\n" .. "-- " .. string.upper(fileName) .. "\n" .. string.rep("-", 67) .. "\n" .. "\n"
    return header
end

local function extractFileName(filePath)
    return filePath:match("^.+/(.+)$")
end

-------------------------------------------------------------------
-- READ AND WRITE
-------------------------------------------------------------------

local function readFile(path)
    local file = io.open(path, "r")

    if not file then
        print("Error: Unable to open file:", path)
        return nil
    end

    local content = file:read("*all")
    file:close()

    return removeComments(content)
end

local function createPath()
    os.execute("mkdir " .. "../retro_artist_toolkit")
end

local function writeFile(path, content)
    local separatedPath = package.config:sub(1,1)
    local directory = path:match("^(.*" .. separatedPath .. ")")
    
    if directory then
        createPath()
    end

    local file = io.open(path, "w")
    if file then
        file:write(content)
        file:close()
    else
        error("Failed to open file: " .. path)
    end
end

-------------------------------------------------------------------
-- BUILD
-------------------------------------------------------------------

for _, tool in ipairs(tool_list) do
    print("----------------------------------------------")
    print("--           START BUILDING TOOL            --")
    print("----------------------------------------------")
    print("TOOL NAME: " .. tool.name)
    print("----------------------------------------------")

    local main_script = readFile(tool.path .. tool.name)
    main_script = removeReturnLines(main_script)
    local combined_dependecies = addDocumentHeader(tool.name)

    for _, dependency in ipairs(tool.dependencies) do
        local dependency_name = extractFileName(dependency)
        local dependency_content = readFile(dependency)

        combined_dependecies = combined_dependecies .. addDependencyHeader(dependency_name)
        combined_dependecies = combined_dependecies .. dependency_content
    end

    local combined_content = combined_dependecies .. "\n" .. addDependencyHeader(tool.name) .. main_script

    writeFile("../retro_artist_toolkit/" .. tool.name, combined_content)
end