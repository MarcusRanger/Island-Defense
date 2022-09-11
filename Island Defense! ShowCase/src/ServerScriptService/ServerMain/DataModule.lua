--[[
	@Author: InTwoo
--]]

local dataModule = {Acquire = nil}
	local dataStoreService = game:GetService("DataStoreService")
		local playerData = dataStoreService:GetDataStore("sdf908qhTestBuildv4.2")
	local sessionData = {}
	local save_interval = 60
	
	local replicatedStorage = game:GetService("ReplicatedStorage")
		local clientData = replicatedStorage.Assets.Remotes.ClientData
		local dataEvent = replicatedStorage.Assets.Remotes.DataEvents
		local purchaseCheck = replicatedStorage.Assets.Remotes.PurchaseCheck
		
		local itemModule = require(replicatedStorage.Assets.Modules.ItemModule)
		
--[!]--
	--//Local Functions
	local function setupPlayerData(player)
		local playerId = "Player_"..player.UserId
		local success, data = pcall(function()
			return playerData:getAsync(playerId)
		end)
		if success then
			if data then
				-- Data has been found!
				print("Loading data for ".. player.Name)
				sessionData[playerId] = data
				print("Data loaded for ".. player.Name)
			else
				-- No data for the player
				sessionData[playerId] = {
					["Coins"] = 5000000,
					["Diamonds"] = 0,
					["Number of Placed Turrets"] = 0,
					["Turret Limit"] = 750000,
					["Placed Turrets"] = {
						["Cannon"] = 0,
						["Machine Gun"] = 0,
						["Rocket Launcher"] = 0,
					},

					["Owned Turrets"] = {
						["Cannon"] = 0,
						["Machine Gun"] = 0,
						["Rocket Launcher"] = 0,
					},

					["Purchased Turrets"] = {
						["Cannon"] = 0,
						["Machine Gun"] = 0,
						["Rocket Launcher"] = 0,
					},

					["Current Weapon"] = "Colt",
					["Owned Weapons"] = {"Colt"},
					["Benchmark"] = 1,

					["Crates Opened"] = 0,
					["Luck"] = 0,
					["First Time"] = false,

					["Kills"] = 0,
					["Deaths"] = 0,
					["Total Damage"] = 0,
					["Round Damage"] = 0,
					
					["Level"] = 1,
					["XP"] = 0,
					["Max XP"] = 25,
					
					["Unlocked Skins"] = 0,
					["Skins"] = {},
					["Equipped Turret Skin"] = "Starter Skin",
					["Equipped Weapon Skin"] = "Starter Skin",

					["Codes Used"] = {},
					["Achievements Unlocked"] = {},
					["Challenges"] = {         
						
					},
					 --[["Kills"] = 0,
						["Turret's Placed"] = 0,
						["Time Spent"] = os.time(),
						["Rounds Survived"] = 0,
						--]]
					["Daily Challenge Timer"] = os.time(),
					["Daily Reward Timer"] = os.time(),
					["Rewards Claimed Streak"] = 0,

					["Ban Logs"] = {},
					["Banned"] = false,

					["Settings"] = {},

					["Owned Passes"] = {},
				}
				print("Data created for "..player.Name)
			end
		else
			warn("Cannot access data for "..player.Name.."!")
			player:Kick("Your data failed to load! Please rejoin the game.")
		end
	end
	
	local function savePlayerData(playerId)
		if sessionData[playerId] then
			local success, err = pcall(function()
				playerData:SetAsync(playerId, sessionData[playerId])
			end)
			if not success then
				warn("Error saving data")
			end
		end
	end
	
	local function saveOnExit(player)
		print("Data saved")
		local playerId = "Player_" .. player.UserId
		dataModule.softWipe(player)
		savePlayerData(playerId)
	end
	
	local function autosave()
		while wait(save_interval) do
			for playerId, data in pairs(sessionData) do
				savePlayerData(playerId)
				print("Saving data")
			end
		end
	end
	
--[!]--
	--//Global Functions	
	function dataModule.tableSearch(targetTable, type, target)
		if type == "index" then
			for i, v in pairs(targetTable) do
				if i == target then
					--print("got it!")
					return v
				end
			end
		elseif type == "detect" then
			for i, v in pairs(targetTable) do
				--print(v,target)
				if v == target then
					--print("aight")
					return true
				end
			end
		end
	end
	
	function dataModule.callPrint(player)
		local success, data = pcall(function()
			return playerData:getAsync(player.UserId)
		end)
		print(success)
		print(data)
	end
	
	function dataModule.findData(player, statName)
		local playerId = "Player_" .. player.UserId
		local targetTable = sessionData[playerId][statName]
--		print(sessionData[playerId][statName])
		return sessionData[playerId][statName]
	end
	
	function dataModule.getData(player, statName)
		local success, data = pcall(function()
			local playerId = "Player_".. player.UserId
			if player.leaderstats:FindFirstChild(statName) ~= nil then
				player.leaderstats[statName].Value = sessionData[playerId][statName]
				print("Getting Data: ".. statName)
			elseif player:FindFirstChild(statName) ~= nil then
				player[statName].Value = sessionData[playerId][statName]
				print("Getting Data: ".. statName)
			else
				warn("dataModule.getData: " .. tostring(statName) .. " not found!")
			end
		end)
		
		if data then
			warn(data)
		end
	end
	
	function dataModule.setData(player, type, statName, value)
		local success, data = pcall(function()
			local playerId = "Player_" .. player.UserId
			if type == "increment" then
				if typeof(sessionData[playerId][statName]) == "number" then
					print("Incrementing Data: ".. statName .. " by ".. value)
					sessionData[playerId][statName] = sessionData[playerId][statName] + value
					if player.leaderstats:FindFirstChild(statName) ~= nil then
						player.leaderstats[statName].Value = sessionData[playerId][statName]
					elseif player:FindFirstChild(statName) ~= nil then
						player[statName].Value = sessionData[playerId][statName] + value
					else
						print("NOT WITH STATS "..statName)
						--warn("Data not player stat")
					end
				else
					warn("dataModule.setData: ".. statName.." does not hold number!")
				end
			elseif type == "change" then
			print("Changing Data: ".. tostring(statName) .. " to ".. tostring(value))
				sessionData[playerId][statName] = value
				if player.leaderstats:FindFirstChild(statName) ~= nil then
					player.leaderstats[statName].Value = sessionData[playerId][statName]
				elseif player:FindFirstChild(statName) ~= nil then
					player[statName].Value = sessionData[playerId][statName]
				else
					warn("Data not player stat")
				end
			end
		end)
		
		if data then
			warn(data)
		end
		if success then
			print(type.."ed data!")
		end
	end
	
	function dataModule.manipulateTable(player, type, statName, item, value)
		local success, data = pcall(function()
			local playerId = "Player_".. player.UserId
			local targetTable = sessionData[playerId][statName]
			if type == "add" then
				if table.getn(targetTable) > 0 then
					table.insert(targetTable, #targetTable, item)
					print("Inserted: ".. item)
				else
					table.insert(targetTable, item)
				end
			elseif type == "remove" then
				--table.remove(targetTable, dataModule.tableSearch(targetTable, "index", item))
				targetTable[item] = nil
				print("Removed: ".. item)
			elseif type == "find" then
				return dataModule.tableSearch(targetTable, "detect", item)
			elseif type == "return-key-value" then
				print("Returning Key-Value: ".. statName .. "[" .. item .. "]: " .. targetTable[item])
				return targetTable[item]
			elseif type == "add-key-value" then
				targetTable[item] = 0
			elseif type == "increment-key-value" then
				print("Incrementing Key-Value: ["..statName.."][".. item .. "] by ".. value)
				if targetTable[item] ~= nil then
					print(targetTable[item], value)
					targetTable[item] = targetTable[item] + value
--				elseif targetTable[item] == nil then
--					print(targetTable, value)
--					targetTable = targetTable + value
				end
			elseif type == "set-key-value" then
				--if targetTable[item] ~= nil then
					targetTable[item] = value
				--end
			else
				warn("Type doesn't exist!")	
			end
		end)
		
		if data then
			warn(data)
			return data
		end
	end
	
	function dataModule.softWipe(player)
		local success, data = pcall(function()
			local playerId = "Player_".. player.UserId
			for i, v in pairs(sessionData[playerId]) do
				if i == "Placed Turrets" or i == "Owned Turrets" or i == "Purchased Turrets" then
					for x, y in pairs(sessionData[playerId][i]) do
						dataModule.manipulateTable(player, "add-key-value", i, x)
					end
				elseif i == "Current Weapon" then
					sessionData[playerId][i] = "Colt"
				elseif i == "Owned Weapons" then
					sessionData[playerId][i] = {"Colt"}
				elseif i == "Benchmark" then
					sessionData[playerId][i] = 1
				elseif i == "Round Damage" or i == "Number of Placed Turrets" then -- or i == "Coins" then
					sessionData[playerId][i] = 0
				elseif i == "Coins" or i == "Diamonds" then
					sessionData[playerId][i] = 750000
				end
			end
			print("Data Wiped")
		end)
		
		if data then
			warn(data)
		end
	end
	
--[!]--

	function dataModule.levelSystem(player)
		local xp = dataModule.findData(player, "XP")
		local maxXP = dataModule.findData(player, "Max XP")
		local level = dataModule.findData(player, "Level")
		if xp >= maxXP then
			dataModule.setData(player, "increment", "Level", 1)
			print("Player Level'd up!", level)
			dataModule.setData(player, "change", "XP", 0)
			dataModule.setData(player, "change", "Max XP", math.floor(maxXP + ((level * (maxXP ^ 0.7925)))))
			maxXP = dataModule.findData(player, "Max XP")
			print("Max XP: ", maxXP)
		end
	end
	

--[!]--
	--//Remotes
	clientData.OnServerInvoke = function(player, type, statName, amount)
		local playerId = "Player_" .. player.UserId
		if type == "returnData" then
			return sessionData[playerId]
		end
	end
	
	--[[
	dataEvent.OnServerEvent:Connect(function(player, type, statName, value, item) -- Super unsafe remote to have dont do this
		if type == "increment" then
			dataModule.setData(player, "increment", statName, value)
		elseif type == "incrementTable" then
			dataModule.manipulateTable(player, "increment-key-value", statName, item, value)
		end
	end)
	--]]
	purchaseCheck.OnServerInvoke = function(player, type, statName, item, hexPlacement)
		local playerId = "Player_" .. player.UserId
		local defenseModule = dataModule.Acquire["DefenseModule"]
		local amount = dataModule.manipulateTable(player, "return-key-value", "Purchased Turrets", item)
		local cost
		if type == "purchaseTurret" then
			if statName == "Coins" then
				cost = itemModule.Turrets[item]["Coins"] + (amount * 80)
			elseif statName == "Diamonds" then
				cost = itemModule.Turrets[item]["Diamonds"] + (amount * 25)
			end
			
			if sessionData[playerId][statName] >= cost then
			
				if defenseModule.PlaceDefense(player, hexPlacement, item) then
					dataModule.setData(player, "increment", statName, -cost)
					dataModule.manipulateTable(player, "increment-key-value", "Owned Turrets", item, 1)
					dataModule.manipulateTable(player, "increment-key-value", "Purchased Turrets", item, 1)
					dataModule.manipulateTable(player, "increment-key-value", "Placed Turrets", item, 1)
					return true
				end
				return false -- if we have the money but there was an error placing item
			else
				return false
			end
		elseif type == "destroyTurret" then
			cost = (itemModule.Turrets[item.Name]["Coins"]) * 0.45
			if dataModule.manipulateTable(player, "return-key-value", "Placed Turrets", item.Name) > 0 then -- we do turret name here because were passing object to destroy in removedefense
				if defenseModule.RemoveDefense(player,item) then -- just incase they pass in turret thats not theirs 
					dataModule.manipulateTable(player, "increment-key-value", "Placed Turrets", item.Name, -1)
					--maybe add owned turrets here
					dataModule.setData(player, "increment", "Coins", cost)
					return true
				end
				return false
			end
			return false
		elseif type == "purchaseWeapon" then
			cost = itemModule.Weapons[item]["Coins"]
			if sessionData[playerId][statName] >= cost and not sessionData[playerId]["Owned Weapons"][item] then
				dataModule.manipulateTable(player, "add", "Owned Weapons", item)
				dataModule.setData(player, "increment", "Coins", -cost)
				return true
			elseif sessionData[playerId]["Owned Weapons"][item] then
				return true
			else
				return false
			end
		end
	end
	
--[!]--
	--//Instantiate
	spawn(autosave)
	game.Players.PlayerAdded:Connect(setupPlayerData)
	
	game.Players.PlayerRemoving:Connect(saveOnExit)
return dataModule