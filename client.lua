ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

OpenWeaponStorage = function()

	local elements = {}

	for i,v in pairs(Config.Recipes) do
		table.insert(elements, {
			label = Config.Recipes[i].name,
			value = Config.Recipes[i].hash
		})
	end

	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "crafting_menu",
		{
			title    = "crafting menu",
			align    = "center",
			elements = elements
		},
	function(data, menu)
		for i,v in pairs(Config.Recipes) do
			if data.current.value == Config.Recipes[i].hash then
				OpenCraftinginfo(i)
			end
		end
		Citizen.Wait(1000)
	end, function(data, menu)
		menu.close()
	end)
end

OpenCraftinginfo = function(g)
	local elements = {}
	for i,v in pairs(Config.Recipes[g].recipe) do
		table.insert(elements, {
			label = Config.Recipes[g].recipe[i].name,
			value = Config.Recipes[g].recipe[i].item,
		})
	end
	table.insert(elements, {label = "confirm", value = "confirm"})
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), "crafting",
	{
		title    = Config.Recipes[g].name.. " craft",
		align    = "center",
		elements = elements
	},
	function(data, menu)
		if data.current.value == "confirm" then
			if not TriggerServerEvent("crafts:craftitem", g) then
				ESX.UI.Menu.CloseAll()
				OpenWeaponStorage()
			else
				ESX.UI.Menu.CloseAll()
			end
		end
		Citizen.Wait(1000)
	end, function(data, menu)
		menu.close()
	end)
end

local Gangdata = {}

for i,v in pairs(Config.Recipes) do
	if Config.Recipes[i].active == true then
		local inDrawingRange = false
		local function isPlayerInRange(coords1, coords2, range)	
			return (Vdist2(coords1.x, coords1.y, coords1.z, coords2.x, coords2.y, coords2.z) < range)
		end
		
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(250)
				inDrawingRange = isPlayerInRange(GetEntityCoords(PlayerPedId()), Config.Recipes[i].coords, 100)
			end
		end)
		
		Citizen.CreateThread(function()
			while true do
				Citizen.Wait(1)
				if inDrawingRange then
					DrawText3D(Config.Recipes[i].coords.x, Config.Recipes[i].coords.y, Config.Recipes[i].coords.z, '[~b~E~w~] Workbench')
					if not display and isPlayerInRange(GetEntityCoords(PlayerPedId()), Config.Recipes[i].coords, 2) then
						SetTextComponentFormat('STRING')
						AddTextComponentString("Press ~INPUT_CONTEXT~ to craft an item")
						DisplayHelpTextFromStringLabel(0, 0, 1, -1)
						if IsControlJustReleased(1, 38) then
							ESX.TriggerServerCallback('crafts:getusegang', function (data)
								Gangdata = data
							end)
							for k,v in pairs(Gangdata) do
								gangname = v.gang
								gangrank = v.gang_rank
							end
							if gangname ~= nil then
								if gangname == Config.Recipes[i].gang then
									if gangrank >= Config.Recipes[i].gang_rank then
										OpenWeaponStorage()
									else
										TriggerEvent('esx:showNotification', "Your gang rank is too low")
									end
								else
									TriggerEvent('esx:showNotification', "Your gang haven't buy the workbanch /discord.gg/ccrp for more info")
								end
							else
								TriggerEvent('esx:showNotification', "You are not in gang")
							end
						end
					end
				end
			end
		end)
	end
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local p = GetGameplayCamCoords()
    local distance = GetDistanceBetweenCoords(p.x, p.y, p.z, x, y, z, 1)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    local scale = scale * fov
    if onScreen then
        SetTextScale(0.35, 0.35)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
        local factor = (string.len(text)) / 370
        DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
    end
end

