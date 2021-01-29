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
        return errorMessage
    end

    local fileInfo = textutils.unserializeJSON(response.readAll())
    if (fileInfo.type ~= "file") then
        return "\"" .. filePath .. "\" is not a file"
    end

    -- Actually download the file
    response, errorMessage = http.get(fileInfo.download_url)
    if (response == nil) then
        return errorMessage
    end

    local fileData = response.readAll()
    local file = fs.open(filePath, "w")
    file.write(fileData)
    file.close()
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
local function downloadFileWithMessages(filePath)
    local w, h = term.getSize()
    local errorMessage = downloadFile(filePath)
    if (errorMessage == nil) then
        print(textApi.centeredText("Successfully downloaded " .. filePath, w))
    else
        print(textApi.centeredText("Could not download " .. filePath, w))
        print(textApi.centeredText(errorMessage, w))
    end
end

local function update()
    local textApi = requireApi("textApi")

    local w, h = term.getSize()
    term.clear()
    term.setCursorPos(1,1)

    print(textApi.centeredText("--  Updating chiriApi  --", w))
    downloadFileWithMessages("chiriApi.lua")

    print(textApi.centeredText("--  Updating API files  --", w))
    if (fs.exists(apiFolder)) then
        local files = fs.list(apiFolder)
        for k, v in pairs(files) do
            downloadFileWithMessages(apiFolder .. "/" .. v)
        end
    end

    print(textApi.centeredText("--  Updating Programs  --", w))
    local files = fs.list("")
    for k, v in pairs(files) do
        if (string.sub(v, -4) == ".lua" and v ~= "chiriApi.lua") then
            downloadFileWithMessages(v)
        end
    end

    print(textApi.centeredText("--  Update completed!  --", w))
end

local function install(programName)
    local textApi = requireApi("textApi")
    local menuApi = requireApi("menuApi")

    local w, h = term.getSize()
    term.clear()
    term.setCursorPos(1,1)

    -- Check if a program name was given, display a list of options otherwise
    if (programName == nil) then
        -- Get a list of files in the github repo root
        local response, errorMessage = http.get("https://api.github.com/repos/" .. githubUser .. "/" .. repoName .. "/contents/")
        if (response == nil) then
            -- File does not exist, nothing to load
            error("Could not load list of programs")
            error("Message: " .. errorMessage)
            return
        end

        local files = textutils.unserializeJSON(response.readAll())
        local availablePrograms = {}

        -- Find all files that end in .lua, exclude this file
        for _, file in pairs(files) do
            if (file.type == "file" and string.sub(file.name, -4) == ".lua" and file.name ~= "chiriApi.lua") then
                table.insert(availablePrograms, file.name)
            end
        end

        -- Add a cancel option to the list
        table.insert(availablePrograms, "Cancel")

        -- Show a menu with the available programs
        print(textApi.centeredText("Please choose a program to install", w))
        programName = requireApi("menuApi").showMenu(availablePrograms, 1, 2)

        -- Clear the terminal
        term.clear()
        term.setCursorPos(1,1)

        -- Check if the user selected cancel
        if (programName == "Cancel") then return end
    end

    if (string.sub(programName, -4) ~= ".lua") then
        programName = programName .. ".lua"
    end

    print(textApi.centeredText("Downloading program \"" .. programName .. "\"", w))
    downloadFileWithMessages(programName)
end

args = {...}
if (args[1] ~= nil) then
    -- An argument was given, meaning this was run as a program.
    if (args[1] == "update") then
        update()
    end

    if (args[1] == "install") then
        install(args[2])
    end
end

return {
    require = requireApi
}
