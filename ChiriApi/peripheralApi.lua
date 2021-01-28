-- No more manually entering peripheral names, prompt the user with a list of current peripherals instead!
-- Values are saved so the computer can be restarted without having to enter the peripherals again

local chiriApi = require("chiriApi")
local menuApi = chiriApi.require("menuApi")
local textApi = chiriApi.require("textApi")

function findPeripheral(name, description)
    -- Switch to our own settings file
    settings.save()
    settings.load(".savedPeripherals")

    -- Check if we already know this peripheral
    local savedPeripheral = settings.get(name)
    if (savedPeripheral ~= nil and peripheral.isPresent(savedPeripheral)) then
        return peripheral.wrap(savedPeripheral)
    end

    -- Peripheral not found, define the setting and create a menu for the user to select it
    settings.define(name, {description = description, type = "string"})

    local x, y = term.getSize()
    term.clear()
    term.setCursorPos(1, 1)
    term.write(textApi.centeredText("Please select the peripheral for " .. name, x))
    term.setCursorPos(1, 2)
    term.write(textApi.centeredText(description, x))
    local selectedPeripheral = menuApi.showMenu(peripheral.getNames(), 2, 3, x - 2, y - 2)
    term.clear()

    settings.set(name, selectedPeripheral)
    settings.save(".savedPeripherals")
    settings.load()
end

return {
    findPeripheral = findPeripheral
}
