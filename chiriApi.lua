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
local function APIrequire(apiName)
    if (not fs.exists(apiFolder .. "/" .. apiName)) then
        local response, errorMessage = http.get("https://api.github.com/repos/" .. githubUser .. "/" .. repoName .. "/contents/" .. apiFolder .. "/" .. apiName .. ".lua")
        if (response == nil) then
            -- File does not exist, nothing to load
            error(apiFolder .."/" .. apiName .. ".lua could not be downloaded")
            error("Message: " .. errorMessage)
            return nil
        end

        local fileInfo = textutils.unserializeJSON(response.readAll())
        if (fileInfo.type ~= "file") then
            error(apiFolder .."/" .. apiName .. ".lua is not a file")
            return nil
        end

        -- Actually download the file
        shell.run("wget " .. fileInfo.download_url .. " " .. apiFolder .. "/" .. apiName)
    end
    return require(apiFolder .. "/" .. apiName)
end

return { require = APIrequire }
