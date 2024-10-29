lib.callback.register('r_whippets:purchaseGas', function(src, flavor)
    local player = GetPlayerPed(src)
    local distance = #(GetEntityCoords(player) - Cfg.Options.WhippetShop.Coords.xyz)
    if distance > 5 then DropPlayer(src, _L('cheater')) return false end
    local added = Core.Inventory.AddItem(src, Flavors[flavor].boxItem, 1)
    if not added then debug('[DEBUG] - Error adding item', src, Flavors[flavor].boxItem) return false end
    Core.Framework.RemoveAccountBalance(src, 'money', Cfg.Options.WhippetShop.Price)
    return true
end)

local function openGasBox(src, flavor)
    local flavorData = Flavors[flavor]
    Core.Inventory.RemoveItem(src, flavorData.boxItem, 1)
    local opened = lib.callback.await('r_whippets:openGasBox', false, flavorData)
    if opened then
        Core.Inventory.AddItem(src, flavorData.bottleItem, 1, { contents = 800 })
    else
        Core.Inventory.AddItem(src, flavorData.boxItem, 1)
    end
end

local function registerUsableItems()
    for flavor, data in pairs(Flavors) do
        Core.Framework.RegisterUsableItem(data.boxItem, function(src, item, itemData)
            openGasBox(src, flavor)
        end)
        Core.Framework.RegisterUsableItem(data.bottleItem, function(src, item, itemData)
            if not itemData then itemData = item end
            if itemData.info then itemData.metadata = itemData.info end
            if not itemData.metadata or not itemData.metadata.contents then debug('[DEBUG] - no metadata found') return end
            TriggerClientEvent('r_whippets:useGas', src, flavor, itemData.metadata.contents)
        end)
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        registerUsableItems()
    end
end)