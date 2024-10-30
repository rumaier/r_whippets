local entities = {}
local bottleFlavor = nil
local bottleContents = nil
local effectStrength = 0

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

local function disableAllControls(duration)
    local start = GetGameTimer()
    while GetGameTimer() - start < duration do
        DisableAllControlActions(0)
        Wait(0)
    end
end

local function passout()
    disableAllControls(5000)
    SetPedToRagdoll(cache.ped, 5000, 5000, 0, 0, 0, 0)
    DoScreenFadeOut(750)
    Core.Framework.Notify(_L('passout'), 'info')
    SetTimeout(5000, function()
        DoScreenFadeIn(500)
        SetTimecycleModifier('default')
        effectStrength = 0
    end)
end

local function decreaseEffectStrength()
    local oldStrength = effectStrength * 100
    local newStrength = (effectStrength * 100) - 20
    for i = oldStrength, newStrength, -1 do
        SetTimecycleModifier('BlackOut')
        effectStrength = math.max((i * 0.01) * 1.0, 0.0)
        SetTimecycleModifierStrength(effectStrength);
        Wait(0)
    end
    if effectStrength <= 0.0 then
        SetTimecycleModifier('default')
        effectStrength = 0
    end
    debug('[DEBUG] - decreased effect strength')
end

local function increaseEffectStrength(duration)
    local oldStrength = effectStrength * 100
    local newStrength = (effectStrength * 100) + 20
    for i = oldStrength, newStrength do
        SetTimecycleModifier('BlackOut')
        effectStrength = (i * 0.01) * 1.0
        SetTimecycleModifierStrength(effectStrength);
        Wait(0)
    end
    if effectStrength >= 1.0 then
        passout()
    end
    SetTimeout((duration * 3) , function()
        decreaseEffectStrength()
    end)
    debug('[DEBUG] - increased effect strength')
end

local function updateContentsInTextUi()
    CreateThread(function()
        for i = 0, 50 do
            local contents = (bottleContents + 50) - i
            Core.Ui.ShowTextUi('E', _L('text_ui', contents))
            Wait(100)
        end
    end)
end

local function useGas()
    bottleContents = bottleContents - 50
    local duration = GetAnimDuration('amb@world_human_drinking@coffee@male@idle_a', 'idle_a')
    AttachEntityToEntity(entities.gasBottle, cache.ped, GetPedBoneIndex(cache.ped, 28422), -0.0089, -0.0009, -0.0678, -4.1979, 10.7573, -13.8231, true, true, false, true, 2, true)
    updateContentsInTextUi()
    if lib.progressCircle({
            duration = duration * 500,
            label = _L('using_gas'),
            position = 'bottom',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
                combat = true,
            },
            anim = {
                dict = 'amb@world_human_drinking@coffee@male@idle_a',
                clip = 'idle_a',
            },
        }) then
        debug('[DEBUG] - used gas')
        increaseEffectStrength(duration)
        if bottleContents <= 0 then
            -- TODO: test if this detaches the entity properly, if not, use DeleteEntity
            Core.Framework.Notify(_L('empty_bottle'), 'info')
            DetachEntity(entities.gasBottle, true, true)
            -- DeleteEntity(entities.gasBottle)
        else
            local ptFxCoords = GetPedBoneCoords(cache.ped, 47495, 0.0, 0.0, 0.0)
            AttachEntityToEntity(entities.gasBottle, cache.ped, GetPedBoneIndex(cache.ped, 28422), 0.0085, 0.0157, -0.0653, 0, 0, 0, true, true, false, true, 2, true)
            Core.Natives.PlayPtFxLooped(ptFxCoords, 'core', 'ent_amb_smoke_gaswork', 0.3, 1000)
            Core.Natives.PlayAnim(cache.ped, 'amb@world_human_drinking@coffee@male@base', 'base', -1, 49, 0.0)
        end
    end
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
    debug('[DEBUG] - pulled out gas')
end

RegisterNetEvent('r_whippets:useGas', function(flavor, contents)
    holdGas(flavor, contents)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        StopAnimTask(cache.ped, 'amb@world_human_drinking@coffee@male@base', 'base', 1.0)
        SetTimecycleModifier('default')
        Core.Ui.HideHelpText()
        Core.Ui.HideTextUi()
        for _, entity in pairs(entities) do
            DeleteEntity(entity)
        end
    end
end)