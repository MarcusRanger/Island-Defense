--[[
	@author: InTwoo
--]]

local itemModule = {Acquire = nil}
	--//Passes
	itemModule.Gamepasses = {
		["Test Gamepass"] = {
			["Info"] = "Yes",
			["ID"] = 0,
		},
	}
	--//Products
	itemModule.Products = {
		["Test Product"] = {
			["Info"] = "Yes",
			["ID"] = 0,
		},
	}
	--//Crates
	itemModule.Crates = {
		["Skins"] = {
			["Crate 1"] = {
				["Diamonds"] = 0,
				["Items"] = {"Skin 1", "Skin 2", "Skin 3"},
			},
			["Crate 2"] = {
				["Diamonds"] = 0,
				["Items"] = {"Skin 1", "Skin 2", "Skin 3"},
			},
		},
		
		["Trails"] = {
			["Crate 1"] = {
				["Diamonds"] = 0,
				["Items"] = {"Trail 1", "Trail 2", "Trail 3"},
			},
			["Crate 2"] = {
				["Diamonds"] = 0,
				["Items"] = {"Trail 1", "Trail 2", "Trail 3"},
			},
		},
	}
	--//Chests
	itemModule.Chests = {
		["Common Chest"] = {
			["Chance"] = 75,
			["Rewards"] = {100, 10}, -- Coins, Diamonds
		},
		["Rare Chest"] = {
			["Chance"] = 20,
			["Rewards"] = {250, 25}, -- Coins, Diamonds
		},
		["Ultimate Chest"] = {
			["Chance"] = 5,
			["Rewards"] = {350, 35}, -- Coins, Diamonds
		},
	}
	--//Skins
	itemModule.Skins = {
		["Skin 1"] = {
			["Info"] = "Skin 1",

			["Crate"] = "Basic Crate",
			["Rarity"] = "Common",
			
			["Diamonds"] = 100,
			["Sell"] = 50,
			
			["Boosts"] = {
				["Coins"] = 1.37,
				["Diamonds"] = 1.01,
				["XP"] = 1.4,
			},
		},
		["Skin 2"] = {
			["Info"] = "Skin 1",

			["Crate"] = "Basic Crate",
			["Rarity"] = "Common",
			
			["Diamonds"] = 100,
			["Sell"] = 50,
			
			["Boosts"] = {
				["Coins"] = 1.37,
				["Diamonds"] = 1.01,
				["XP"] = 1.4,
			},
		},
	}
	--//Weapons
	itemModule.Weapons = {
		["Colt"] = {
			["Info"] = "Weapon 1",
			
			["Coins"] = 100,
			
			["Damage"] = 10,
		},
		["Deagle"] = {
			["Info"] = "Weapon 2",
		
			["Coins"] = 100,
			
			["Damage"] = 10,
		},
		["DualHandGuns"] = {
			["Info"] = "Weapon 2",
		
			["Coins"] = 100,
			
			["Damage"] = 10,
		},
		["M249"] = {
			["Info"] = "Weapon 2",
		
			["Coins"] = 100,
			
			["Damage"] = 10,
		},
		["Minigun"] = {
			["Info"] = "Weapon 2",
		
			["Coins"] = 100,
			
			["Damage"] = 10,
		},
		["Shotgun"] = {
			["Info"] = "Weapon 2",
		
			["Coins"] = 100,
			
			["Damage"] = 10,
		},
		["Sniper"] = {
			["Info"] = "Weapon 2",
		
			["Coins"] = 100,
			
			["Damage"] = 10,
		},
	}
	--//Turrets
	itemModule.Turrets = {
		["Cannon"] = {
			["Info"] = "Turret 1",
			
			["Coins"] = 100,
			["Diamonds"] = 100,
			
			["Damage"] = 10,
			["MaxHealth"] = 100,
			
			["Target"] = "Both",
			["Radius"] = 100,
			
			["Required Level"] = 1,
		},
		["Machine Gun"] = {
			["Info"] = "Turret 1",
			
			["Coins"] = 100,
			["Diamonds"] = 100,
			
			["Damage"] = 10,
			["MaxHealth"] = 100,
			
			["Target"] = "Ground",
			["Radius"] = 100,
			
			["Required Level"] = 1,
		},
		["Rocket Launcher"] = {
			["Info"] = "Turret 1",
			
			["Coins"] = 100,
			["Diamonds"] = 100,
			
			["Damage"] = 10,
			["MaxHealth"] = 100,
			
			["Target"] = "Both",
			["Radius"] = 100,
			
			["Required Level"] = 1,
		},
	}
	--//Enemies
	itemModule.Enemies = {
		["Tier 1"] = { -- Rounds % 1, 2 ONLY
			[1] = {
				["Name"] = "Kamikaze",
				["Info"] = "Enemy",
	
				["Damage"] = 1,
				["Health"] = 100,
				
				["XP"] = 15,
				
				["Rewards"] = {
					["Coins"] = 10,
					["Diamonds"] = 1,
				},
			},
			[2] = {
				["Name"] = "Ice Mage",
				["Info"] = "Enemy",
	
				["Damage"] = 1,
				["Health"] = 100,
	
				["XP"] = 15,
				
				["Rewards"] = {
					["Coins"] = 10,
					["Diamonds"] = 1,
				},
			},
		},
		["Tier 2"] = { -- Rounds % 3, 5 ONLY
			[1] = {
				["Name"] = "Red Witch",
				["Info"] = "Enemy",
	
				["Damage"] = 5,
				["Health"] = 100,
	
				["XP"] = 15,
				
				["Rewards"] = {
					["Coins"] = 10,
					["Diamonds"] = 1,
				},
			},
			[2] = {
				["Name"] = "Invisible Soldier",
				["Info"] = "Enemy",
	
				["Damage"] = 5,
				["Health"] = 100,
	
				["XP"] = 15,
				
				["Rewards"] = {
					["Coins"] = 10,
					["Diamonds"] = 1,
				},
			},
			[3] = {
				["Name"] = "Kamikaze",
				["Info"] = "Enemy",
	
				["Damage"] = 1,
				["Health"] = 100,
				
				["XP"] = 15,
				
				["Rewards"] = {
					["Coins"] = 10,
					["Diamonds"] = 1,
				},
			},
			[4] = {
				["Name"] = "Ice Mage",
				["Info"] = "Enemy",
	
				["Damage"] = 1,
				["Health"] = 100,
	
				["XP"] = 15,
				
				["Rewards"] = {
					["Coins"] = 10,
					["Diamonds"] = 1,
				},
			},
		},
		["Tier 3"] = { -- Rounds % 7, 10(not 5) ONLY
			[1] = {
				["Name"] = "Fire Boss",
				["Info"] = "Enemy",
	
				["Damage"] = 10,
				["Health"] = 100,
	
				["XP"] = 15,
				
				["Rewards"] = {
					["Coins"] = 10,
					["Diamonds"] = 1,
				},
			},
		[2] = {
				["Name"] = "Red Witch",
				["Info"] = "Enemy",
	
				["Damage"] = 5,
				["Health"] = 100,
	
				["XP"] = 15,
				
				["Rewards"] = {
					["Coins"] = 10,
					["Diamonds"] = 1,
				},
			},
			[3] = {
				["Name"] = "Invisible Soldier",
				["Info"] = "Enemy",
	
				["Damage"] = 5,
				["Health"] = 100,
	
				["XP"] = 15,
				
				["Rewards"] = {
					["Coins"] = 10,
					["Diamonds"] = 1,
				},
			},
			[4] = {
				["Name"] = "Kamikaze",
				["Info"] = "Enemy",
	
				["Damage"] = 1,
				["Health"] = 100,
				
				["XP"] = 15,
				
				["Rewards"] = {
					["Coins"] = 10,
					["Diamonds"] = 1,
				},
			},
			[5] = {
				["Name"] = "Ice Mage",
				["Info"] = "Enemy",
	
				["Damage"] = 1,
				["Health"] = 100,
	
				["XP"] = 15,
				
				["Rewards"] = {
					["Coins"] = 10,
					["Diamonds"] = 1,
				},
			
			},
		}
	}
	--//Trails
	itemModule.Trails = {
		["Trail 1"] = {
			["Info"] = "Trail 1",
			
			["Coins"] = 100,
			["Diamonds"] = 100,
		},
	}
	
	--//Challenges
	itemModule.Challenges = {
		["Kills"] = {
			["Goal"] = 75,
			["Reward"] = 100,
			["Description"] = "Mob Slayer: Slay NPCs",
		},
		["Turrets Placed"] = {
			["Goal"] = 50,
			["Reward"] = 100,
			["Description"] = "Mechanic: Construct Turrets",
		},
		["Turrets Removed"] = {
			["Goal"] = 50,
			["Reward"] = 100,
			["Description"] = "Mechanic: Remove Turrets",
		},
		["Turret Health Repair"] = {
			["Goal"] = 50,
			["Reward"] = 100,
			["Description"] = "Mechanic: Repair Turrets",
		},
		["Time Played"] = {
			["Goal"] = 8,
			["Reward"] = 100,
			["Description"] = "Play Time: Hours",
		},
		["Damage Dealt"] = {
			["Goal"] = 50,
			["Reward"] = 100,
			["Description"] = "Mob Slayer: Deal Damage",
		},
		["Rounds Survived"] = {
			["Goal"] = 50,
			["Reward"] = 100,
			["Description"] = "Mob Slayer: Survive Rounds",
		},
		["Bosses Defeated"] = {
			["Goal"] = 50,
			["Reward"] = 100,
			["Description"] = "Mob Slayer: Slay Bosses",
		},
	}
return itemModule