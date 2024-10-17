lib.callback.register('r_whippets:purchaseGas', function(src, flavor)
    local player = GetPlayerPed(src)
    local distance = #(GetEntityCoords(player) - Cfg.Options.WhippetShop.Coords.xyz)
    if distance > 5 then DropPlayer(src, _L('cheater')) return false end
    local added = Core.Inventory.AddItem(src, Flavors[flavor].boxItem, 1)
    if not added then debug('[DEBUG] - Error adding item', src, Flavors[flavor].boxItem) return false end
    Core.Framework.RemoveAccountBalance(src, 'money', Cfg.Options.WhippetShop.Price)
    return true
end)

local function openGasBox()
    -- TODO: Open gas box
end

local function registerUsableItems()
    for flavor, data in pairs(Flavors) do
        Core.Framework.RegisterUsableItem(data.boxItem, function(src, item, itemData)
            if not itemData then itemData = item end
            if itemData.info then itemData.metadata = itemData.info end
            if not itemData.metadata then itemData.metadata = { contents = 800 } end
            local opened = lib.callback.await('r_whippets:openGasBox', data.boxProp, data.bottleProp, itemData.metadata.contents)
            if not opened then return end
            Core.Inventory.RemoveItem(src, data.boxItem, 1)
        end)
        Core.Framework.RegisterUsableItem(data.bottleItem, function(src, item, itemData)
            if not itemData then itemData = item end
            if itemData.info then itemData.metadata = itemData.info end
            if not itemData.metadata then itemData.metadata = { contents = 800 } end
            
        end)
    end
end

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        registerUsableItems()
    end
end)