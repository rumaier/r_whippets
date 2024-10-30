local entities = {}
local shopBlip = nil

lib.callback.register('r_whippets:openGasBox', function(flavorData)
    if lib.progressCircle({
            duration = 5000,
            label = _L('opening_box'),
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                combat = true,
            },
            anim = {
                dict = 'missheistdockssetup1clipboard@idle_a',
                clip = 'idle_a',
            },
            prop = {
                model = flavorData.boxProp,
                bone = 60309,
                pos = vec3(-0.0973, -0.0161, -0.0709),
                rot = vec3(15.4404, -5.0550, 17.0007)
            },
        }) then
        return true
    else
        return false
    end
end)

local function buyGas(flavor)
    local alert = lib.alertDialog({ header = _L('buy_gas'), content = _L('buy_gas_confirm', flavor, Cfg.Options.WhippetShop.Price), centered = true, cancel = true })
    if alert == 'cancel' then return end
    local purchased = lib.callback.await('r_whippets:purchaseGas', false, flavor)
    if not purchased then lib.showContext('whippet_shop') debug('[ERROR] - Purchase failed', flavor) return end
    Core.Framework.Notify(_L('purchased_gas', string.format('%s gas', flavor), Cfg.Options.WhippetShop.Price), 'success')
end

local function openWhippetShop()
    local options = {}
    for flavor, data in pairs(Flavors) do
        local itemInfo = Core.Inventory.GetItemInfo(data.bottleItem)
        if not itemInfo then debug('[ERROR] - Item info not found', data.bottleItem) return end
        table.insert(options, {
            title = _L('shop_item', itemInfo.label, Cfg.Options.WhippetShop.Price),
            icon = Cfg.Server.InventoryImagePath and string.format('%s/%s.png', Cfg.Server.InventoryImagePath, data.bottleItem) or 'rocket',
            image = Cfg.Server.InventoryImagePath and string.format('%s/%s.png', Cfg.Server.InventoryImagePath, data.boxItem) or 'rocket',
            onSelect = function()
                buyGas(flavor)
            end
        })
    end
    lib.registerContext({
        id = 'whippet_shop',
        title = _L('whippet_shop'),
        options = options,
    })
    PlayPedAmbientSpeechNative(entities.shop, 'GENERIC_HI', 'SPEECH_PARAMS_FORCE')
    lib.showContext('whippet_shop')
end

function SetupWhippetShop()
    local shop = Cfg.Options.WhippetShop
    shopBlip = Core.Natives.CreateBlip(shop.Coords.xyz, 368, 7, 1.2, _L('whippet_shop'), true)
    lib.points.new({ coords = shop.Coords.xyz, distance = 150,
        onEnter = function()
            if entities.shop then return end
            entities.shop = Core.Natives.CreateNpc(shop.PedModel, shop.Coords.xyz, shop.Coords.w, false)
            Core.Natives.SetEntityProperties(entities.shop, true, true, true)
            TaskStartScenarioInPlace(entities.shop, 'WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT', 0, true)
            Core.Target.AddLocalEntity(entities.shop, {
                {
                    label = _L('whippet_shop'),
                    name = 'whippet_shop',
                    icon = 'fas fa-user-astronaut',
                    distance = 1.5,
                    onSelect = function()
                        openWhippetShop()
                    end
                }
            })
            debug('[DEBUG] - Whippet shop ped spawned', entities.shop)
        end,
        onExit = function()
            Core.Target.RemoveLocalEntity(entities.shop)
            DeleteEntity(entities.shop)
            entities.shop = nil
            debug('[DEBUG] - Whippet shop ped removed', entities.shop)
        end,
    })
end
 
-- REMOVE: This is a temporary event handler to test the whippet shop
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        SetupWhippetShop()
    end
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, entity in pairs(entities) do
            DeleteEntity(entity)
        end
        Core.Natives.RemoveBlip(shopBlip)
    end
end)
