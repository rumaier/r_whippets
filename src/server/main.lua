lib.callback.register('r_whippets:purchaseGas', function(src, flavor)
    local player = GetPlayerPed(src)
    local distance = #(GetEntityCoords(player) - Cfg.Options.WhippetShop.Coords.xyz)
    if distance > 5 then DropPlayer(src, _L('cheater')) return false end
    local added = Core.Inventory.AddItem(src, Flavors[flavor], 1)
    if not added then debug('[DEBUG] - Error adding item', src, Flavors[flavor]) return false end
    Core.Framework.RemoveAccountBalance(src, 'money', Cfg.Options.WhippetShop.Price)
    return true
end)