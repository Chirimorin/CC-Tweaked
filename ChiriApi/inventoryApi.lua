-- Functions for inventory management

local expect = (require "cc.expect").expect

-- Checks the inventory for items matching the filter function
-- Returns the first slot the item was found in or nil if no items match the given tag
local function findItemByFilter(inventory, filter)
    expect(1, inventory, "table")
    expect(2, filter, "function")

    for i = 1, inventory.size(), 1 do
        local item = inventory.getItemDetail(i)
        if (item ~= nil && filter(item)) then
            return i, item
        end
    end
end

-- Checks the inventory for items matching the filter function
-- Returns a table with the matching items (with the slots as the key)
local function findItemsByFilter(inventory, filter)
    expect(1, inventory, "table")
    expect(2, filter, "function")

    local result = {}

    for i = 1, inventory.size(), 1 do
        local item = inventory.getItemDetail(i)
        if (item ~= nil && filter(item)) then
            result[i] = item
        end
    end

    return result
end

-- Shorthand filter for finding an item by name
local function findItemByName(inventory, itemName)
    expect(1, inventory, "table")
    expect(2, name, "string")

    return findItemByFilter(inventory, function(item) return item.name == itemName end)
end

-- Shorthand filter for finding items by name
local function findItemsByName(inventory, itemName)
    expect(1, inventory, "table")
    expect(2, name, "string")

    return findItemsByFilter(inventory, function(item) return item.name == itemName end)
end

-- Shorthand filter for finding an item by tag
local function findItemByTag(inventory, itemTag)
    expect(1, inventory, "table")
    expect(2, itemTag, "string")

    return findItemByFilter(inventory, function(item)
        return item.tags ~= nil and item.tags(itemTag) == true
    end)
end

-- Shorthand filter for finding items by tag
local function findItemsByTag(inventory, itemTag)
    expect(1, inventory, "table")
    expect(2, itemTag, "string")

    return findItemsByFilter(inventory, function(item)
        return item.tags ~= nil and item.tags(itemTag) == true
    end)
end

return {
    findItemByFilter = findItemByFilter,
    findItemsByFilter = findItemsByFilter,
    findItemByName = findItemByName,
    findItemsByName = findItemsByName,
    findItemByTag = findItemByTag,
    findItemsByTag = findItemsByTag
}
