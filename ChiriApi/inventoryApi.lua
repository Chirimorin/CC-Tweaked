-- Functions for inventory management

local expect = (require "cc.expect").expect

-- Checks the inventory for items with the given name
-- Returns the slot the item was found in or nil if no items match the given name
local function findItemByName(inventory, itemName)
    expect(1, inventory, "table")
    expect(2, name, "string")

    for i = 1, inventory.size(), 1 do
        local item = inventory.getItemDetail(i)
        if (item ~= nil and item.name == itemName) then
            return i
        end
    end

    return nil
end

-- Checks the inventory for items with the given name
-- Returns a table with the matching items (with the slots as the key)
local function findItemsByName(inventory, itemName)
    expect(1, inventory, "table")
    expect(2, name, "string")

    result = {}

    for i = 1, inventory.size(), 1 do
        local item = inventory.getItemDetail(i)
        if (item ~= nil and item.name == itemName) then
            result[i] = item
        end
    end

    return result
end

-- Checks the inventory for items with the given tag
-- Returns the slot the item was found in or nil if no items match the given tag
local function findItemByTag(inventory, itemTag)
    expect(1, inventory, "table")
    expect(2, itemTag, "string")

    for i = 1, inventory.size(), 1 do
        local item = inventory.getItemDetail(i)
        if (item ~= nil and item.tags ~= nil and item.tags[itemTag] == true) then
            return i
        end
    end

    return nil
end

-- Checks the inventory for items with the given tag
-- Returns a table with the matching items (with the slots as the key)
local function findItemsByTag(inventory, itemTag)
    expect(1, inventory, "table")
    expect(2, itemTag, "string")

    result = {}

    for i = 1, inventory.size(), 1 do
        local item = inventory.getItemDetail(i)
        if (item ~= nil and item.tags ~= nil and item.tags[itemTag] == true) then
            result[i] = item
        end
    end

    return result
end

return {
    findItemByName = findItemByName,
    findItemsByName = findItemsByName,
    findItemByTag = findItemByTag,
    findItemsByTag = findItemsByTag
}
