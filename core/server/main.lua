RegisterNetEvent("r_whippets:ptfxEvent", function(netId)
    TriggerClientEvent("r_whippets:ptfxEvent", -1, netId)
end)

lib.callback.register('r_whippets:shareGasWithNearestPlayer', function(src, flavor, contents)
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    local target = lib.getNearbyPlayers(playerCoords, 1.0)
    for _, player in pairs(target) do
        if player.id ~= src then
            print('[DEBUG] - sharing gas with', player.id)
            TriggerClientEvent('r_whippets:takeGas', player.id, flavor, contents)
            return true
        end
    end
    return false
end)

lib.callback.register('r_whippets:purchaseGas', function(src, flavor, location)
    local player = GetPlayerPed(src)
    local distance = #(GetEntityCoords(player) - location.xyz)
    if distance > 5 then DropPlayer(src, _L('cheater')) return false end
    local balance = Core.Framework.getAccountBalance(src, 'money')
    if balance < Cfg.Options.WhippetShop.Price then 
        TriggerClientEvent('r_bridge:notify', src, _L('notify_title'), _L('insufficient_funds'), 'error')
        return false 
    end
    local added = Core.Inventory.addItem(src, Flavors[flavor].boxItem, 1)
    if not added then _debug('[DEBUG] - Error adding item', src, Flavors[flavor].boxItem) return false end
    Core.Framework.removeAccountBalance(src, 'money', Cfg.Options.WhippetShop.Price)
    return true
end)

lib.callback.register('r_whippets:storeGas', function(src, flavor, contents, bottleEntity)
    local player = GetPlayerPed(src)
    bottleEntity = NetworkGetEntityFromNetworkId(bottleEntity)
    if not DoesEntityExist(bottleEntity) or GetEntityAttachedTo(bottleEntity) ~= player then return false end
    local durability = math.floor((100/800) * contents)
    local added = Core.Inventory.addItem(src, Flavors[flavor].bottleItem, 1, { contents = contents, durability = durability })
    if not added then return false end
    return true
end)

local function openGasBox(src, flavor)
    local flavorData = Flavors[flavor]
    Core.Inventory.removeItem(src, flavorData.boxItem, 1)
    local opened = lib.callback.await('r_whippets:openGasBox', src, flavor)
    if not opened then
        Core.Inventory.addItem(src, flavorData.boxItem, 1)
    end
end

local function registerUsableItems()
    for flavor, data in pairs(Flavors) do
        Core.Framework.registerUsableItem(data.boxItem, function(src, item, itemData)
            openGasBox(src, flavor)
        end)
        Core.Framework.registerUsableItem(data.bottleItem, function(src, item, itemData)
            if not itemData then itemData = item end
            if itemData.info then itemData.metadata = itemData.info end
            if not itemData.metadata or not itemData.metadata.contents then _debug('[DEBUG] - no metadata found') return end
            Core.Inventory.removeItem(src, itemData.name, 1, itemData.metadata)
            TriggerClientEvent('r_whippets:holdGas', src, flavor, itemData.metadata.contents)
        end)
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        registerUsableItems()
    end
end)