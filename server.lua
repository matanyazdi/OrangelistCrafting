ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)ESX = obj end)

function checkhaveenough(recipies)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i,v in pairs(recipies) do
		print(recipies[i].item)
		local item = xPlayer.getInventoryItem(recipies[i].item).count
		if item < recipies[i].quantity then
			return false
		end
	end
	return true
end

ESX.RegisterServerCallback('crafts:getusegang', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	   local identifier = xPlayer.getIdentifier()
	   MySQL.Async.fetchAll(('SELECT `gang`, `gang_rank` FROM `users` WHERE identifier=@identifier'), {['@identifier'] = identifier}, function(result)    
		   cb(result)
	   end)
   end)


function takeitems(recipies)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	for i,v in pairs(recipies) do
		xPlayer.removeInventoryItem(recipies[i].item, recipies[i].quantity)
	end
end


RegisterNetEvent("crafts:craftitem")
AddEventHandler("crafts:craftitem", function(index)
	local recipies = Config.Recipes[index].recipe
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	if checkhaveenough(recipies) then
		TriggerClientEvent('esx:showNotification', _source, 'crafting in progress...')
		takeitems(recipies)
		weapon = Config.Recipes[index].hash
		if Config.Recipes[index].type == "weapon" then
			xPlayer.addWeapon(weapon, 300)
		else
			xPlayer.addInventoryItem(weapon, 1)
		end
		return true
	else
		TriggerClientEvent('esx:showNotification', _source, 'You dont have enough items')
		return false
	end
end)