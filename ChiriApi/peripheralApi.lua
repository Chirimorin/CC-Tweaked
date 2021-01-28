-- No more manually entering peripheral names, prompt the user with a list of current peripherals instead!
-- Values are saved so the computer can be restarted without having to enter the peripherals again

local expect = (require "cc.expect").expect

local chiriApi = require("chiriApi")
local menuApi = chiriApi.require("menuApi")
local textApi = chiriApi.require("textApi")

function findPeripheral(name, description)
    expect(1, name, "string")
    expect(2, description, "string", "nil")

    -- Switch to our own settings file
    settings.save()
    settings.load(".savedPeripherals")

    -- Check if we already know this peripheral
    local savedPeripheral = settings.get(name)
    if (savedPeripheral ~= nil and peripheral.isPresent(savedPeripheral)) then
        return peripheral.wrap(savedPeripheral)
    end

    -- Peripheral not found, create a menu with all attached peripherals
    local w, h = term.getSize()
    term.clear()
    textApi.writeCenteredText("Please select \"" .. name .. "\"", 1, 1, w)
    local selectedPeripheral = ""
    if (description ~= nil) then
        textApi.writeCenteredText(description, 1, 2, w)
        selectedPeripheral = menuApi.showMenu(peripheral.getNames(), 2, 3, w - 2, h - 2)
    else
        selectedPeripheral = menuApi.showMenu(peripheral.getNames(), 2, 2, w - 2, h - 1)
    end
    term.clear()
    term.setCursorPos(1, 1)

    -- Save and switch back to the default settings file
    settings.define(name, {description = description, type = "string"})
    settings.set(name, selectedPeripheral)
    settings.save(".savedPeripherals")
    settings.load()
end

return {
    findPeripheral = findPeripheral
}
