local entities = {}
local blips = {}

RegisterNetEvent("r_whippets:ptfxEvent", function(netId)
    if not NetworkDoesNetworkIdExist(netId) then return end
    local entity = NetworkGetEntityFromNetworkId(netId)
    local distance = #(GetEntityCoords(cache.ped) - GetEntityCoords(entity))
    if not DoesEntityExist(entity) or distance > 50 then return end
    local ptFxCoords = GetPedBoneCoords(entity, 47495, 0.0, 0.0, 0.0)
    Core.Natives.PlayPtFxLooped(ptFxCoords, 'core', 'ent_amb_smoke_gaswork', 0.1, 500)
end)

lib.callback.register('r_whippets:openGasBox', function(flavor)
    local flavorData = Flavors[flavor]
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
            TriggerEvent('r_whippets:holdGas', flavor, 800)
        return true
    else
        return false
    end
end)

local function buyGas(flavor, location)
    local alert = lib.alertDialog({ header = _L('buy_gas'), content = _L('buy_gas_confirm', flavor, Cfg.Options.WhippetShop.Price), centered = true, cancel = true })
    if alert == 'cancel' then return end
    local purchased = lib.callback.await('r_whippets:purchaseGas', false, flavor, location)
    if not purchased then lib.showContext('whippet_shop') debug('[DEBUG] - Purchase failed', flavor) return end
    Core.Framework.Notify(_L('purchased_gas', string.format('%s gas', flavor), Cfg.Options.WhippetShop.Price), 'success')
end

local function openWhippetShop(location)
    local options = {}
    for flavor, data in pairs(Flavors) do
        local itemInfo = Core.Inventory.GetItemInfo(data.bottleItem)
        if not itemInfo then debug('[ERROR] - Item info not found', data.bottleItem) return end
        table.insert(options, {
            title = _L('shop_item', itemInfo.label, Cfg.Options.WhippetShop.Price),
            icon = Cfg.Server.InventoryImagePath and string.format('%s/%s.png', Cfg.Server.InventoryImagePath, data.bottleItem) or 'rocket',
            image = Cfg.Server.InventoryImagePath and string.format('%s/%s.png', Cfg.Server.InventoryImagePath, data.boxItem) or 'rocket',
            onSelect = function()
                buyGas(flavor, location)
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
    for _, coords in pairs(shop.Locations) do
        table.insert(blips, Core.Natives.CreateBlip(coords.xyz, shop.Blip.Sprite, shop.Blip.Color, shop.Blip.Scale, shop.Blip.Label, true))
        lib.points.new({ coords = coords.xyz, distance = 150,
        onEnter = function()
            if DoesEntityExist(entities.shopPed) then return end
            entities.shopPed = Core.Natives.CreateNpc(shop.PedModel, coords.xyz, coords.w, false)
            Core.Natives.SetEntityProperties(entities.shopPed, true, true, true)
            entities.shopGas = Core.Natives.CreateProp(Flavors['banana'].bottleProp, GetEntityCoords(entities.shopPed), GetEntityHeading(entities.shopPed), false)
            AttachEntityToEntity(entities.shopGas, entities.shopPed, GetPedBoneIndex(entities.shopPed, 28422), -0.0089, -0.0009, -0.0678, -4.1979, 10.7573, -13.8231, true, true, false, true, 2, true)
            Core.Natives.PlayAnim(entities.shopPed, 'amb@world_human_drinking@coffee@male@base', 'base', -1, 49, 0.0)
            Core.Target.AddLocalEntity(entities.shopPed, {
                {
                    label = _L('whippet_shop'),
                    name = 'whippet_shop',
                    icon = 'fas fa-user-astronaut',
                    distance = 1.5,
                    onSelect = function()
                        openWhippetShop(coords)
                    end
                }
            })
            debug('[DEBUG] - Whippet shop ped spawned', entities.shopPed)
        end,
        onExit = function()
            Core.Target.RemoveLocalEntity(entities.shopPed)
            DeleteEntity(entities.shopGas)
            DeleteEntity(entities.shopPed)
            entities.shopGas = nil
            entities.shopPed = nil
            debug('[DEBUG] - Whippet shop ped removed', entities.shopPed)
        end,
    })
    end
end

-- NUI Functions

function ShowControlsUi(contents)
    SendNUIMessage({
        action = 'showControls',
        contents = contents,
    })
end

function HideControlsUi()
    SendNUIMessage({
        action = 'hideControls',
    })
end

function UpdateUiProgressBar(contents)
    SendNUIMessage({
        action = 'updateProgressBar',
        contents = contents,
    })
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, entity in pairs(entities) do
            DeleteEntity(entity)
        end
        for _, blip in pairs(blips) do
            RemoveBlip(blip)
        end
    end
end)
