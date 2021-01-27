-- This contains functions to easily create simple menus

local chiriApi = require("chiriApi")
local textApi = chiriApi.require("textApi")

local function writeMenuItem(text, width, isSelected)
    if (isSelected == true) then
        term.write("[" .. textApi.centeredText(text, width - 2) .. "]")
    else
        term.write(" " .. textApi.centeredText(text, width - 2) .. " ")
    end
end

-- Displays a menu with the given options (table of strings)
-- Blocks while waiting for user input
-- Returns the chosen item
local function showMenu(menuItems, x, y, w, h)
    if (type(menuItems) != "table") then
        error("Expected menuItems to be a table, got " .. type(menuItems) .. " instead.")
        return nil
    end

    tW, tH = term.getSize()

    -- Default values
    x = x or 1
    y = y or 1
    w = w or tW
    h = h or tH

    -- Make sure this will fit on the screen

    w = math.max(6, math.min(tW-x, w))
    h = math.max(1, math.min(tH-y, h))

    local selectedIndex = 1 -- This is Lua, arrays start at 1
    local menuSize = 0
    for _ in pairs(menuItems) do menuSize = menuSize + 1 end

    if (menuSize > h) then
        write("scrolling menus not supported yet...")
    else
        while true do
            -- draw the menu
            for i = 1, menuSize, 1 do
                term.setCursorPos(x, y + i - 1)
                writeMenuItem(menuItems[i], w, i == selectedIndex)
            end

            local event, key, is_held = os.pullEvent("key")
            if (key == keys.up) then
                if (selectionIndex == 1) then
                    selectionIndex = menuSize
                else
                    selectionIndex = selectionIndex - 1
                end
            elseif (key == keys.down) then
                if (selectionIndex == menuSize) then
                    selectionIndex = 1
                else
                    selectionIndex = selectionIndex + 1
                end
            elseif (key == keys.enter and not is_held) then
                return i, menuItems[selectionIndex]
            end
        end
    end
end

return {
    showMenu = showMenu
}
