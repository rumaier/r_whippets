Core = exports['r_bridge']:returnCoreObject()

function SendWebhook(src, event, ...)
    if not Cfg.Webhook.Enabled then return end
    local name = '' if src > 0 then name = GetPlayerName(src) end
    local identifier = Core.Framework.GetPlayerIdentifier(src) or ''
    PerformHttpRequest(Cfg.Webhook.Url, function(err, text, headers)
    end, 'POST', json.encode({
        username = 'Resource Logs',
        avatar_url = 'https://i.ibb.co/z700S5H/square.png',
        embeds = {
            {
                color = 0x2C1B47,
                title = event,
                author = {
                    name = GetCurrentResourceName(),
                    icon_url = 'https://i.ibb.co/z700S5H/square.png',
                    url = 'https://discord.gg/r-scripts'
                },
                thumbnail = {
                    url = 'https://i.ibb.co/z700S5H/square.png'
                },
                fields = {
                    { name = _L('player_id'),  value = src,        inline = true },
                    { name = _L('username'),   value = name,       inline = true },
                    { name = _L('identifier'), value = identifier, inline = false },
                },
                timestamp = os.date('!%Y-%m-%dT%H:%M:%S'),
                footer = {
                    text = 'r_scripts',
                    icon_url = 'https://i.ibb.co/z700S5H/square.png',
                },
            }
        }
    }), { ['Content-Type'] = 'application/json' })
end

local function checkResourceVersion()
    if not Cfg.Server.VersionCheck then return end
    Core.VersionCheck(GetCurrentResourceName())
    SetTimeout(3600000, checkResourceVersion)
end

function _debug(...)
    if Cfg.Debug then
        print(...)
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() == resourceName) then
        print('------------------------------')
        print(_L('version', resourceName, GetResourceMetadata(resourceName, 'version', 0)))
        if GetResourceState('r_bridge') ~= 'started' then
            print(_L('no_bridge'))
        else
            print(_L('bridge_detected'))
        end
        print('------------------------------')
        checkResourceVersion()
    end
end)