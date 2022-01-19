ESX = nil
local tattoos = {}
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

AddEventHandler('skinchanger:modelLoaded', function()
	ESX.TriggerServerCallback('requestPlayerTattoos', function(tattooList)
		if tattooList then
			for k,v in pairs(tattooList) do
				AddPedDecorationFromHashes(PlayerPedId(), GetHashKey(v.Collection), GetHashKey(v.Tattoo))
			end
			tattoos = tattooList
		end
	end)
end)


function ClearTattoos()
    ClearPedDecorations(PlayerPedId())
end

function UpdateTattoos()
    ClearPedDecorations(PlayerPedId())
    for k,v in pairs(tattoos) do
        AddPedDecorationFromHashes(PlayerPedId(), GetHashKey(v.Collection), GetHashKey(v.Tattoo))      
    end
end


function NewTattoo(Collection,Tattoo)
    table.insert(tattoos, {
        Collection = Collection,
        Tattoo = Tattoo
    })
    UpdateTattoos()
    TriggerServerEvent('updateTattoos', tattoos)
end