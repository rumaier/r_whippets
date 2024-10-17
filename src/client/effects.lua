local entities = {}
local bottleContents = nil
local effectStrength = 0

function StartUsingGas(prop, contents)
    -- TODO: Attach gas bottle to player, start loop that tracks contents and storage of bottle in inventory
end

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

-- REMOVE: This is a temporary event handler to test the whippet effects
AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        SetTimecycleModifier('default')
    end
end)