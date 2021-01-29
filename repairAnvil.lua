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

    if (anvil.getItemDetail(1) == nil) then
        local slot = inventoryApi.findItemByFilter(inputChest, needsRepair)
        if (slot ~= nil)
            inputChest.pushItems(peripheral.getName(anvil), slot)
        end
    end

    sleep(1)
end
