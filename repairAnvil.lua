local chiriApi = require("chiriApi")
local peripheralApi = chiriApi.require("peripheralApi")
local inventoryApi = chiriApi.require("inventoryApi")

local inputChest = peripheralApi.findPeripheral("inputChest", "The chest for broken items")
local outputChest = peripheralApi.findPeripheral("outputChest", "The chest for repaired items, can be the same as inputChest")
local anvil = peripheralApi.findPeripheral("anvil", "The powered repair anvil")

local function needsRepair(item)
    return item ~= nil and item.damage ~= nil and item.damage > 0
end

while true do
    -- Empty output slot
    if (anvil.getItemDetail(2) ~= nil) then
        anvil.pushItems(peripheral.getName(outputChest), 2)
    end

    -- Remove repaired items from the input slot (sometimes the anvil doesn't properly move the item after repair)
    if (not needsRepair(anvil.getItemDetail(1))) then
        anvil.pushItems(peripheral.getName(outputChest), 1)
    end

    -- Default sleep time for when the anvil is idle.
    -- If the anvil is not idle, sleep time is calculated based on the damage of the item
    local sleepTime = 10

    -- Move an item needing repair to the anvil if a slot is free
    local anvilItem = anvil.getItemDetail(1)
    if (anvilItem == nil) then
        local slot, item = inventoryApi.findItemByFilter(inputChest, needsRepair)
        if (slot ~= nil) then
            inputChest.pushItems(peripheral.getName(anvil), slot)
            -- The diamond powered anvil repairs 1 damage per tick
            -- Add 5 ticks of slack to give items a chance to move around
            sleepTime = (item.damage * 0.05) + 0.25
        end
    else
        -- Apparently we underestimated the repair time
        -- This shouldn't happen if the sleep time calculation above is correct, but we'll take a few extra ticks here
        print("Anvil is still repairing an item, " .. anvilItem.damage .. " damage left")
        sleepTime = (anvilItem.damage * 0.05) + 0.50
    end

    sleep(sleepTime)
end
