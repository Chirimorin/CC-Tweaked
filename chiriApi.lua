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
    local response, errorMessage = http.get("https://raw.githubusercontent.com/" .. githubUser .. "/" .. repoName .. "/main/" .. filePath)
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
    local textApi = requireApi("textApi")
    local w, h = term.getSize()
    local textColor = term.getTextColor()

    local errorMessage = downloadFile(filePath)
    if (errorMessage == nil) then
        term.setTextColor(colors.green)
        print(textApi.centeredText(filePath, w))
    else
        term.setTextColor(colors.red)
        print(textApi.centeredText(filePath .. ": " .. errorMessage, w))
    end

    term.setTextColor(textColor)
    return errorMessage
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
        if (string.sub(v, -4) == ".lua" and v ~= "chiriApi.lua" and v ~= "startup.lua") then
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
        local response, errorMessage = http.get("https://api.github.com/repos/" .. githubUser .. "/" .. repoName .. "/git/trees/main")
        if (response == nil) then
            -- File does not exist, nothing to load
            error("Could not load list of programs")
            error("Message: " .. errorMessage)
            return
        end

        local files = textutils.unserializeJSON(response.readAll()).tree
        local availablePrograms = {}

        -- Find all files that end in .lua, exclude this file
        for _, file in pairs(files) do
            if (string.sub(file.path, -4) == ".lua" and file.path ~= "chiriApi.lua") then
                table.insert(availablePrograms, file.path)
            end
        end

        -- Add a cancel option to the list
        table.insert(availablePrograms, "Cancel")

        -- Show a menu with the available programs
        print(textApi.centeredText("Choose a program to install", w))
        programName = menuApi.showMenu(availablePrograms, 1, 2)

        -- Check if the user selected cancel
        if (programName == "Cancel") then return end
    end

    if (string.sub(programName, -4) ~= ".lua") then
        programName = programName .. ".lua"
    end

    print(textApi.centeredText("Downloading program \"" .. programName .. "\"", w))
    if (downloadFileWithMessages(programName) == nil) then
        print(textApi.centeredText("Autostart " .. programName .. "?", w))
        termX, termY = term.getCursorPos()
        local x = math.floor((w-5)/2)
        if (menuApi.showMenu({"Yes", "No"}, x, termY, 5, 2) == "Yes") then
            print(textApi.centeredText("Creating startup.lua...", w))

            local file = fs.open("startup.lua", "w")
            file.write("shell.run(\"" .. programName .. "\")")
            file.close()
        end
    end
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
