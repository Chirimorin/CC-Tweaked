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
local function downloadFile(filePath)
    local response, errorMessage = http.get("https://api.github.com/repos/" .. githubUser .. "/" .. repoName .. "/contents/" .. filePath)
    if (response == nil) then
        -- File does not exist, nothing to load
        error(filePath .. " could not be downloaded")
        error("Message: " .. errorMessage)
        return nil
    end

    local fileInfo = textutils.unserializeJSON(response.readAll())
    if (fileInfo.type ~= "file") then
        error(filePath .. " is not a file")
        return nil
    end

    -- Actually download the file
    shell.run("wget " .. fileInfo.download_url .. " " .. filePath)
end

local function requireApi(apiName)
    local filePath = apiFolder .. "/" .. apiName .. ".lua"

    if (not fs.exists(filePath)) then
        downloadFile(filePath)
    end
    return require(apiFolder .. "/" .. apiName)
end

-------------------------
--  PROGRAM FUNCTIONS  --
-------------------------
args = {...}
if (args[1] ~= nil) then
    -- An argument was given, meaning this was run as a program.
    if (args[1] == "update") then
        print("Updating ChiriApi...")
        fs.delete("chiriApi.lua")
        downloadFile("chiriApi.lua")

        print("Updating API files")
        if (fs.exists(apiFolder)) then
            local files = list(apiFolder)
            for k, v in pairs(files) do
                fs.delete(apiFolder .. "/" .. v)
                downloadFile(apiFolder .. "/" .. v)
            end
        end
        print("Update completed!")
    end
end

return {
    require = requireApi
}
