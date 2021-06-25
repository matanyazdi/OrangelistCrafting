Config = {}

-- Ammo given by default to crafted weapons
Config.WeaponAmmo = 300

Config.Recipes = {
	{
		active = true,
		coords = { x = -572.202, y = 285.6187, z = 79.5 },
		hash = "WEAPON_ASSAULTRIFLE",
		name = "assault rifle",
		type = "weapon", --weapon / else(doesn't matter)
		job = "police",
		job_rank = 4,
		recipe = 
		{
			{
			item = "bread",
			quantity = 1,
			name = "bread - 1"
			},
		}
	}
}

