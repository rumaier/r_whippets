Cfg = Cfg or {}

local resource = GetCurrentResourceName()
local initialized = false

local function onClientReady()
    if initialized then return end
    if not Cfg.Language then return end
    initialized = true
    if Cfg.Options.WhippetShop.Enabled then
        SetupWhippetShop()
    end
end

local function applyClientConfig(config)
    for key, value in pairs(config) do
        Cfg[key] = value
    end
    CreateThread(function()
        Wait(0)
        TriggerEvent(resource .. ':clientConfigLoaded')
    end)
end

local function loadClientConfig()
    local config
    for attempt = 1, 10 do
        local success, response = pcall(lib.callback.await, resource .. ':getClientConfig', false)
        if success and type(response) == 'table' then
            config = response
            break
        end
        Wait(attempt * 250)
    end
    if not config then
        print('^1[' .. resource .. ']^0 Failed to load client config; retrying in the background')
        CreateThread(function()
            while true do
                Wait(1000)
                local success, response = pcall(lib.callback.await, resource .. ':getClientConfig', false)
                if success and type(response) == 'table' then
                    applyClientConfig(response)
                    return
                end
            end
        end)
        return
    end
    applyClientConfig(config)
end

---Preserves the old 3-flag entity property API (setPedInert is all-or-nothing).
function setEntityProperties(entity, frozen, invincible, oblivious)
    FreezeEntityPosition(entity, frozen)
    SetEntityInvincible(entity, invincible)
    SetBlockingOfNonTemporaryEvents(entity, oblivious)
end

AddEventHandler('r_bridge:playerLoaded', onClientReady)

AddEventHandler(resource .. ':clientConfigLoaded', function()
    if bridge.framework.isPlayerLoaded() then
        onClientReady()
    end
end)

loadClientConfig()
