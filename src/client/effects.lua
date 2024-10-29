local entities = {}
local bottleContents = nil
local effectStrength = 0

local openBone = 60309
local openOffset = {-0.0973, -0.0161, -0.0709, 15.4404, -5.0550, 17.0007}
local holdBone = 28422
local holdOffset = {0.0085, 0.0157, -0.0653, 0, 0, 0}
local useBone = 28422
local useOffset = {-0.0089, -0.0009, -0.0678, -4.1979, 10.7573, -13.8231}

local function storeGas()

end

local function passout()
    
end

local function increaseEffectStrength()

end

local function useGas()

end

local function startUsingGas(flavor, contents)
    -- TODO: Attach gas bottle to player, start NUI. 
    -- register NUI callbacks for using gas button, and storing gas button
    -- if the player presses E, useGas()
    -- if the player presses ESC, storeGas()
end

RegisterNetEvent('r_whippets:useGas', function(flavor, contents)
end)

-- TODO: implement this into the effect functionality
RegisterCommand('testtimecycle', function()
    local newStrength = (effectStrength * 100) + 20
    for i = effectStrength * 100, newStrength do
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