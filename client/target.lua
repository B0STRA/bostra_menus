local zones = {}

function CreateTargets()
    if Config.Target == 'ox' then
        for i = 1, #Config.Menus do
            local menu = Config.Menus[i]
            if menu.prop and not menu.propSpawned then
                if Config.Debug then print("creating prop:" .. menu.prop) end
                if not menu.rotation then
                    MakeProp(menu.prop, vec3(menu.coords.x, menu.coords.y, menu.coords.z))
                    menu.propSpawned = true
                else
                    MakeProp(menu.prop, vec3(menu.coords.x, menu.coords.y, menu.coords.z),
                        vec3(menu.rotation.x, menu.rotation.y, menu.rotation.z))
                    menu.propSpawned = true
                end
            end
            local options = {
                {
                    icon = "fas fa-utensils",
                    label = "Menu",
                    name = menu.name,
                    distance = 2.5,
                    onSelect = function()
                        StartScene(menu.prop)
                        local popup = OpenImageMenu(menu.name, menu.menuLink)
                        if Config.Debug then print('Menu Opened') end
                        if not popup then
                            ClearPedTasks(PlayerPedId())
                            DestroyProp(menu.prop)
                        end
                    end,
                }
            }
            local parameters = {
                coords = menu.coords,
                radius = menu.radius,
                debug = Config.Debug,
                drawSprite = true,
                options = options
            }
            local zone = exports.ox_target:addSphereZone(parameters)
            zones[#zones + 1] = zone
        end
    elseif Config.Target == 'qb' then
        for i = 1, #Config.Menus do
            local menu = Config.Menus[i]
            if menu.prop and not menu.propSpawned then
                if Config.Debug then print("creating prop:" .. menu.prop) end
                if not menu.rotation then
                    MakeProp(menu.prop, vec3(menu.coords.x, menu.coords.y, menu.coords.z))
                    menu.propSpawned = true
                else
                    MakeProp(menu.prop, vec3(menu.coords.x, menu.coords.y, menu.coords.z),
                        vec3(menu.rotation.x, menu.rotation.y, menu.rotation.z))
                    menu.propSpawned = true
                end
            end
            local zone = exports['qb-target']:AddCircleZone(menu.name, menu.coords, menu.radius,
                {
                    name = menu.name .. tostring(math.random(1, 1000)),
                    debugPoly = Config.Debug,
                }, {
                    options = {
                        {
                            num = 1,
                            icon = 'fas fa-utensils',
                            label = "Menu",
                            targeticon = 'fas fa-utensils',
                            action = function()
                                StartScene(menu.prop)
                                local popup = OpenImageMenu(menu.name, menu.menuLink)
                                if Config.Debug then print('Menu Opened') end
                                if not popup then
                                    ClearPedTasks(PlayerPedId())
                                    DestroyProp(menu.prop)
                                end
                            end,
                        } },
                    distance = 3,
                })
            zones[#zones + 1] = zone
        end
    elseif Config.Target == 'lib' then
        HasProp = false
        for i = 1, #Config.Menus do
            local menu = Config.Menus[i]
            if menu.prop and not menu.propSpawned then
                if Config.Debug then print("creating prop:" .. menu.prop) end
                if not menu.rotation then
                    MakeProp(menu.prop, vec3(menu.coords.x, menu.coords.y, menu.coords.z))
                    menu.propSpawned = true
                else
                    MakeProp(menu.prop, vec3(menu.coords.x, menu.coords.y, menu.coords.z),
                        vec3(menu.rotation.x, menu.rotation.y, menu.rotation.z))
                    menu.propSpawned = true
                end
            end
            local params = {
                coords = vec3(menu.coords.x, menu.coords.y, menu.coords.z + 1),
                size = vec3(menu.radius, menu.radius, 3.0),
                rotation = menu.coords.w,
                onEnter = function()
                    lib.showTextUI('Press [E] to view menu')
                end,
                inside = function()
                    if IsControlJustReleased(0, 38) then
                        lib.hideTextUI()
                        StartScene(menu.prop)
                        HasProp = OpenImageMenu(menu.name, menu.menuLink)
                    end
                    if not HasProp then
                        ClearPedTasks(PlayerPedId())
                        DestroyProp(menu.prop)
                    else
                        return lib.showTextUI('Press [E] to replace menu')
                    end
                end,
                onExit = function()
                    DestroyProp(menu.prop)
                    StopAnimTask(PlayerPedId(), 'amb@world_human_clipboard@male@idle_a', 'idle_a', 1.0)
                    lib.hideTextUI()
                end,
                debug = Config.Debug,
            }
            local zone = lib.zones.box(params)
            zones[#zones + 1] = zone
        end
    end
end

function DestroyTargets()
    if Config.Target == 'ox' then
        for i = 1, #zones do
            if Config.Debug then
                print('destroying zone: ' .. zones[i].name)
            end
            exports.ox_target:removeZone(zones[i])
            for i = 1, #Config.Menus do
                local menu = Config.Menus[i]
                menu.propSpawned = false
            end
        end
    elseif Config.Target == 'qb' then
        for i = 1, #zones do
            if Config.Debug then
                print('destroying zone: ' .. zones[i].name)
            end
            exports['qb-target']:RemoveZone(zones[i])
            for i = 1, #Config.Menus do
                local menu = Config.Menus[i]
                menu.propSpawned = false
            end
        end
    elseif Config.Target == 'lib' then
        for i = 1, #zones do
            if Config.Debug then
                print('destroying zone ')
            end
            local zone = zones[i]
            zone:remove()
            for i = 1, #Config.Menus do
                local menu = Config.Menus[i]
                menu.propSpawned = false
            end
        end
    end
end
