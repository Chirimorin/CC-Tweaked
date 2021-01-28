-- Functions for inventory management

local expect = (require "cc.expect").expect

-- Checks the inventory for items with the given name
-- Returns the slot the item was found in or nil if no items match the given name
local function findItemByName(inventory, itemName)
    expect(1, inventory, "table")
    expect(2, name, "string")

    for i = 1, inventory.size() do
        local item = inventory.getItemDetail(i)
        if (item ~= nil and item.name == itemName) then
            return i
        end
    end

    return nil
end

-- Checks the inventory for items with the given tag
-- Returns the slot the item was found in or nil if no items match the given tag
local function findItemByTag(inventory, itemTag)
    expect(1, inventory, "table")
    expect(2, itemTag, "string")

    for i = 1, inventory.size() do
        local item = inventory.getItemDetail(i)
        if (item ~= nil and item.tags ~= nil and item.tags[itemTag] == true) then
            return i
        end
    end

    return nil
end


return {
    findItemByName = findItemByName,
    findItemByTag = findItemByTag
}
