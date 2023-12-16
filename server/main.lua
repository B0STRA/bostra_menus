lib.addCommand('newmenu', {
    help = 'Add a new  menu',
    params = {},
    restricted = Config.Admin
}, function(source, args, raw)
    TriggerClientEvent('bostra_menus:client:placeProp', source)
end)