local Logger = require("logger")

local file_cleaner = {}

function file_cleaner:removeComments(content)
    Logger:print(Logger.Weight.BOLD .. "[PROCESS] *** REMOVING COMMENTS ***", Logger.Colors.CYAN)

    local lines = {}
    for line in content:gmatch("(.-)\n") do
        if not line:match("^%s*%-%-") then
            table.insert(lines, line)
        end
    end

    Logger:print("Comments were successfully remover", Logger.Colors.GREEN)
    Logger:divider(Logger.Colors.CYAN)
    return table.concat(lines, "\n")
end

function file_cleaner:removeLocalRequires(content)
    Logger:print(Logger.Weight.BOLD .. "[PROCESS] *** REMOVING LOCAL REQUIRES ***", Logger.Colors.CYAN)

    local lines = {}
    local wordsToRemove = { "local", "require" }
    local removedLines = 0

    Logger:print("Looking for words: local, require", Logger.Colors.CYAN)

    for line in content:gmatch("[^\r\n]+") do
        for _, word in ipairs(wordsToRemove) do
            if not line:find(word) then
                table.insert(lines, line)
                break
            else
                removedLines = removedLines + 1
            end
        end
    end

    if removedLines > 0 then
        Logger:print(removedLines .. " lines were deleted", Logger.Colors.GREEN)
        Logger:divider(Logger.Colors.CYAN)
    else
        Logger:print("The file has no local requires", Logger.Colors.CYAN)
        Logger:divider(Logger.Colors.CYAN)
    end

    return table.concat(lines, "\n")
end

return file_cleaner