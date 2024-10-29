local entities = {}
local bottleFlavor = nil
local bottleContents = nil
local effectStrength = 0

local useBone = 28422
local useOffset = {-0.0089, -0.0009, -0.0678, -4.1979, 10.7573, -13.8231}

local function storeGas()
    local netId = NetworkGetNetworkIdFromEntity(entities.gasBottle)
    Core.Natives.PlayAnim(cache.ped, 'melee@holster', 'holster', 1000, 49, 0.0)
    local stored = lib.callback.await('r_whippets:storeGas', false, bottleFlavor, bottleContents, netId)
    if stored then
        DeleteEntity(entities.gasBottle)
        Core.Ui.HideHelpText()
        Core.Ui.HideTextUi()
        bottleFlavor = nil
        bottleContents = nil
        entities.gasBottle = nil
    end
end

local function passout()
    -- TODO: trigger this if effect strength is maxed out
    -- ragdoll player and fade screen out to black
    -- notify they have passed out
    -- wake up in config value time
end

local function increaseEffectStrength()
    -- TODO: progress circle, when done, increase effect strength
    -- if effect strength is maxed out, trigger passout
end

local function useGas()
    -- TODO: play animation and loop textui contents down
    -- reduce bottlecontents by 50
    -- increase effect strength
end

local function startListeningForInput()
    local listening = true
    while listening and entities.gasBottle do
        DisableFrontendThisFrame()
        if IsControlJustPressed(0, 38) then
            useGas()
        elseif IsControlJustPressed(0, 73) then
            storeGas()
            SetTimeout(500, function()
                listening = false
            end)
        end
        Wait(0)
    end
end

local function holdGas(flavor, contents)
    bottleFlavor = flavor
    bottleContents = contents
    local prop = Flavors[flavor].bottleProp
    entities.gasBottle = Core.Natives.CreateProp(prop, GetEntityCoords(cache.ped), GetEntityHeading(cache.ped), true)
    AttachEntityToEntity(entities.gasBottle, cache.ped, GetPedBoneIndex(cache.ped, 28422), 0.0085, 0.0157, -0.0653, 0, 0, 0, true, true, false, true, 2, true)
    Core.Natives.PlayAnim(cache.ped, 'amb@world_human_drinking@coffee@male@base', 'base', -1, 49, 0.0)
    Core.Ui.ShowTextUi('E', _L('text_ui', contents))
    Core.Ui.ShowHelpText(_L('help_text'))
    startListeningForInput()
end

RegisterNetEvent('r_whippets:useGas', function(flavor, contents)
    holdGas(flavor, contents)
end)

-- TODO: implement this into the effect functionality
RegisterCommand('testtimecycle', function()
    local oldStrength = effectStrength * 100
    local newStrength = (effectStrength * 100) + 20
    for i = oldStrength, newStrength do
        SetTimecycleModifier('BlackOut')
        effectStrength = (i * 0.01) * 1.0
        SetTimecycleModifierStrength(effectStrength);
        Wait(0)
    end
end, false)

RegisterCommand('testanim', function()
    local dict = 'amb@world_human_drinking@coffee@male@base'
    local anim = 'base'
    Core.Natives.PlayAnim(cache.ped, dict, anim, 30000, 49, 0.0)
end, false)
-- REMOVE: remove all these commands around here, they are just for testing purposes
RegisterCommand('testui', function()
    Core.Ui.ShowTextUi('E', 'Use Gas (800g)')
    Core.Ui.ShowHelpText('Press ESC to store gas')
    Wait(2000)
    SetTimeout(5000, function()
        Core.Ui.HideTextUi()
        Core.Ui.HideHelpText()
    end)
end, false)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SetTimecycleModifier('default')
        for _, entity in pairs(entities) do
            DeleteEntity(entity)
        end
    end
end)