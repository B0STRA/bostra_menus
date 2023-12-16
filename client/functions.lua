local menus = {}

function OpenImageMenu(business, menuLink)
    local alert = lib.alertDialog({
        header = business,
        content = '![Image](' .. menuLink .. ')',
        centered = true,
        cancel = true,
        size = 'xl',
        overflow = true,
        labels = {
            cancel = '(CANCEL)  Put Menu Down',
            confirm = '(HOLD)  Ready to Order?'
        }
    })
    if alert ~= 'confirm' then
        return false
    else
        return true
    end
end

function StartScene(prop)
    lib.requestAnimDict('amb@world_human_clipboard@male@idle_a')
    if not IsEntityPlayingAnim(cache.ped, 'amb@world_human_clipboard@male@idle_a', 'idle_a', 3) then
        if Config.Debug then print('Playing Anim') end
        TaskPlayAnim(cache.ped, 'amb@world_human_clipboard@male@idle_a', 'idle_a', 8.0, 1.0, -1, 49, 0, false, false,
            false)
    end
    if prop then
        prop = prop
        if Config.Debug then
            print(prop .. ' :' .. "Created Scene Prop")
        end
        local menu = MakeProp(prop, vec3(0, 0, 0))
        AttachEntityToEntity(menu, cache.ped, 42, 0.12803444204758, -0.050830318893319, 0.15303928295378, 118.49381484199,
            -61.227353691263, 179.97864726996, true, true, false, true, 1, true)
        menus[#menus + 1] = menu
    end
end

function MakeProp(prop, coords, rotation)
    lib.requestModel(prop)
    local menu = CreateObject(prop, coords.x, coords.y, coords.z, true, false, false)
    SetEntityCoords(menu, coords.x, coords.y, coords.z, false, false, false, false)
    if rotation then
        SetEntityRotation(menu, rotation.x, rotation.y, rotation.z, 2, true)
    end
    FreezeEntityPosition(menu, true)
    SetEntityInvincible(menu, true)
    SetEntityAsMissionEntity(menu, true, true)
    menus[#menus + 1] = menu
    if Config.Debug then
        print(prop .. ' :' .. "Created Prop")
    end
    return menu
end

function DestroyProp(prop)
    if prop then
        for k, v in pairs(GetGamePool('CObject')) do
            if IsEntityAttachedToEntity(cache.ped, v) then
                if Config.Debug then
                    print('Found Attached Prop')
                end
                SetEntityAsMissionEntity(v, false, false)
                DeleteEntity(v)
            end
        end
    else
        for k, v in pairs(menus) do
            if DoesEntityExist(v) then
                if Config.Debug then
                    print('Found Attached Prop')
                end
                SetEntityAsMissionEntity(v, false, false)
                DeleteEntity(v)
            end
        end
    end
end

function FormatMenuData(data)
    local formattedConfig = {
        name = data.name,
        coords = vec4(data.coords.x, data.coords.y, data.coords.z, data.coords.w or 0),
        rotation = vec3(data.rotation.x, data.rotation.y, data.rotation.z),
        radius = data.radius,
        menuLink = data.menuLink,
        prop = data.prop,
        propSpawned = data.propSpawned
    }

    local propString
    if type(data.prop) == "string" then
        propString = string.format('"%s"', data.prop)
    else
        propString = '""'
    end

    local menuLinkString = string.format('"%s"', data.menuLink)

    lib.setClipboard(string.format([[{
    name = "%s",
    coords = vec4(%f, %f, %f, %f),
    rotation = vec3(%f, %f, %f),
    radius = %f,
    menuLink = %s,
    prop = %s,
    propSpawned = false,
}]], data.name, data.coords.x, data.coords.y, data.coords.z, data.coords.w or 0, data.rotation.x, data.rotation.y,
        data.rotation.z, data.radius, menuLinkString,
        propString))

    return formattedConfig
end
