Core = exports['r_bridge']:returnCoreObject()

local onPlayerLoaded = Core.Framework.Current == 'es_extended' and 'esx:playerLoaded' or 'QBCore:Client:OnPlayerLoaded'
RegisterNetEvent(onPlayerLoaded, function()
    if Cfg.Options.WhippetShop.Enabled then
        SetupWhippetShop()
    end
end)

Cfg.Server.InventoryImagePath = Core.Inventory.IconPath or false

function _debug(...)
    if Cfg.Debug then
        print(...)
    end
end