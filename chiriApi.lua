-- The main file which handles intalling and loading chiriApi files
-- Simply call chiriApi.require("apiName") and it will download it from the given github repo if required

----------------
--  SETTINGS  --
----------------
local githubUser = "Chirimorin"
local repoName = "ComputerCraft-scripts"
local apiFolder = "ChiriApi"

---------------------
--  API FUNCTIONS  --
---------------------
local function require(apiName)
    if (not fs.exists(apiFolder .. "/" .. apiName)) then
            local response, error = http.get("https://api.github.com/repos/" .. githubUser .. "/" .. repoName .. "/contents/" .. apiFolder .. "/" .. "apiName" .. ".lua")
            if (response == nil) then
                -- File does not exist, nothing to load
                error("ChiriApi \"" .. apiName .. "\" was not found")
                return nil
            end

            local fileInfo = textutils.unserializeJSON(response.readAll())
            if (fileInfo.type ~= "file") then
                error("ChiriApi \"" .. apiName .. "\" is not a file")
                return nil
            end

            -- Actually download the file
            shell.run("wget " .. fileInfo.download_url .. " " .. apiFolder .. "/" .. apiName)
        end
    end
    return require(apiFolder .. "/" .. apiName)
end

return { require = require }
