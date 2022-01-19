ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function ()
    MySQL.Async.fetchAll('SELECT * FROM users', {}, function (RowsSelected)
        if RowsSelected[1].tattoos == nil then
            print('Tattoo Spalte wird hinzugefuegt!')
            MySQL.Async.execute('ALTER TABLE users ADD COLUMN tattoos LONGTEXT NOT NULL DEFAULT "[]"')
        end
    end)
end)


ESX.RegisterServerCallback('requestPlayerTattoos', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT tattoos FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1].tattoos then
				cb(json.decode(result[1].tattoos))
			else
				cb()
			end
		end)
	else
		cb()
	end
end)

RegisterServerEvent('updateTattoos')
AddEventHandler('updateTattoos', function (tattooList)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1].tattoos then
            local obj = json.decode(result[1].tattoos)
            if obj ~= tattooList then
                MySQL.Async.execute('UPDATE users SET tattoos = @tattoos WHERE identifier = @identifier', {
                    ['@tattoos'] = json.encode(tattooList),
                    ['@identifier'] = xPlayer.identifier
                })
            end
        end
    end)

end)