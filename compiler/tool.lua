--
-- tool.lua
-- Retro Artist Toolkit
--
-- Created by Renan Maganha on June 11, 2024
--

Tool = {

    new = function (self, name, path, dependencies)
        Object = {
            name         = name,
            path         = path,
            dependencies = dependencies
        }
        setmetatable(Object, self)
        self.__index = self

        return Object
    end

}

return Tool