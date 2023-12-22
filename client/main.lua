RegisterNetEvent('bostra_menus:client:createProps', function()
    for _, menu in ipairs(Config.Menus) do
        if menu.prop and not menu.propSpawned then
            if Config.Debug then print(menu.prop) end
            if menu.rotation then
                MakeProp(menu.prop, vec4(menu.coords.x, menu.coords.y, menu.coords.z, menu.coords.w),
                    vec3(menu.rotation.x, menu.rotation.y, menu.rotation.z))
            else
                MakeProp(menu.prop, vec4(menu.coords.x, menu.coords.y, menu.coords.z, menu.coords.w))
            end
        elseif not menu.prop or menu.prop == '' then
            if Config.Debug then print('no prop:createProps') end
            return
        end
    end
end)

RegisterNetEvent('bostra_menus:client:reloadMenu', function()
    for _, menu in ipairs(Config.Menus) do
        if menu.propSpawned and menu.prop then
            if Config.Debug then print('destroying prop:reloadmenu') end
            DestroyProp(menu.prop)
        end
    end
    TriggerEvent('bostra_menus:client:createProps')
end)

RegisterNetEvent('bostra_menus:client:placeProp', function()
    local image = lib.inputDialog('Insert Your Menu Image', {
        { type = 'input',  label = 'Unique Menu Title:', default = tostring(math.random(1, 10000)),   required = true,                                                      min = 4,         max = 30 },
        { type = 'input',  label = 'Menu Prop:',         default = 'prop_drinkmenu',                  description = 'Recommended to look at:  \n https://forge.plebmasters.de/', required = true, min = 4,  max = 50 },
        { type = 'input',  label = 'Image URL:',         default = 'https://i.imgur.com/f5ocMnr.jpg', description = '1080 height max recommended',                          required = true },
        { type = 'number', label = 'Size',               default = 2.0,                               description = 'Size of the menu point',                               required = true, min = 0.2 },
    })

    if Config.Debug then print(json.encode(image)) end

    if not image then
        return
    end
    local offset = GetOffsetFromEntityInWorldCoords(cache.ped, 0, 1.0, 0)

    local model = joaat(image[2])
    lib.requestModel(model, 5000)

    local object = CreateObject(model, offset.x, offset.y, offset.z, true, false, false)

    local objectPositionData = useGizmo(object)
    if Config.Debug then print(json.encode(objectPositionData)) end
    local menu = {
        name = image[1],
        coords = vec4(objectPositionData.position.x, objectPositionData.position.y, objectPositionData.position.z,
            objectPositionData.rotation.z),
        rotation = vec3(objectPositionData.rotation.x, objectPositionData.rotation.y, objectPositionData.rotation.z),
        radius = image[4],
        prop = image[2],
        propSpawned = false,
        menuLink = image[3],
    }

    if Config.Debug then print(json.encode(menu), { indent = true }) end
    if not menu then
        return
    end
    Config.Menus[#Config.Menus + 1] = menu
    if DoesEntityExist(object) then
        DeleteEntity(object)
    end
    DestroyTargets()
    FormatMenuData(menu)
    lib.notify({ title = 'Menus:', description = 'Config Data Copied to Clipboard', duration = 60000, type = 'success' })
    TriggerEvent('bostra_menus:client:reloadMenu')
    CreateTargets()
end)

AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() ~= resource then
        return
    end
    CreateTargets()
    TriggerEvent('bostra_menus:client:reloadMenu')
end)

AddEventHandler('onResourceStop', function(resource)
    if GetCurrentResourceName() ~= resource then
        return
    end
    DestroyTargets()
    DestroyProp()
end)

if GetResourceState('qb-core') == 'started' then
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        Wait(1000)
        CreateTargets()
        TriggerEvent('bostra_menus:client:createProps')
    end)
end

if GetResourceState('esx_core') == 'started' then
    AddEventHandler('esx:playerLoaded', function()
        Wait(1000)
        CreateTargets()
        TriggerEvent('bostra_menus:client:createProps')
    end)
end
