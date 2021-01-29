-- This contains functions to easily create simple menus

local expect = (require "cc.expect").expect

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
    expect(1, menuItems, "table")

    tW, tH = term.getSize()

    -- Default values
    x = x or 1
    y = y or 1
    w = w or tW
    h = h or tH

    -- Make sure this will fit on the screen
    w = math.max(6, math.min(tW-x+1, w))
    h = math.max(1, math.min(tH-y+1, h))

    local selectedIndex = 1 -- This is Lua, arrays start at 1
    local scrollPosition = 1 -- The index of the top displayed row
    local menuSize = 0 -- The total amount of options in this menu
    for _ in pairs(menuItems) do menuSize = menuSize + 1 end

    while true do
        local oldX, oldY = term.getCursorPos()
        -- Draw the menu
        for i = scrollPosition, math.min(h + scrollPosition - 1, menuSize), 1 do
            term.setCursorPos(x, y + i - scrollPosition)
            if (i == scrollPosition and i ~= 1) then
                -- This is the top position, but not the first menuItem, hide it with an arrow.
                writeMenuItem("^", w, false)
            elseif (i == h + scrollPosition - 1 and i ~= menuSize) then
                -- This is the bottom position, but not the last menuItem, hide it with an arrow.
                writeMenuItem("V", w, false)
            else
                -- This is a normal menu item
                writeMenuItem(menuItems[i], w, i == selectedIndex)
            end
        end
        term.setCursorPos(oldX, oldY)

        -- Wait for a keypress
        local event, key, is_held = os.pullEvent("key")
        if (key == keys.up) then
            if (selectedIndex == 1) then
                if (not is_held) then
                    -- Wrap to the bottom
                    selectedIndex = menuSize
                    scrollPosition = math.max(menuSize - h + 1, 1)
                end
            else
                -- Select the previous item, scroll if needed
                selectedIndex = selectedIndex - 1
                if (scrollPosition == selectedIndex and scrollPosition ~= 1) then
                    scrollPosition = scrollPosition - 1
                end
            end
        elseif (key == keys.down) then
            if (selectedIndex == menuSize) then
                if (not is_held) then
                    -- Wrap to the top
                    selectedIndex = 1
                    scrollPosition = 1
                end
            else
                -- Select the next item, scroll if needed
                selectedIndex = selectedIndex + 1
                if (scrollPosition + h - 1 == selectedIndex and scrollPosition ~= menuSize - h + 1) then
                    scrollPosition = scrollPosition + 1
                end
            end
        elseif (key == keys.enter and not is_held) then
            -- Clear the menu area
            oldX, oldY = term.getCursorPos()
            for i = y, y+h, 1 do
                term.setCursorPos(x, i)
                term.write(string.rep(" ", w))
            end
            term.setCursorPos(oldX, oldY)

            -- Return the selected item
            return menuItems[selectedIndex], selectedIndex
        end
    end
end

return {
    showMenu = showMenu
}
