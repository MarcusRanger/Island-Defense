--[[
	@author: InTwoo
--]]

--//Services
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local pathfindingService = game:GetService("PathfindingService")
	local collectionService = game:GetService("CollectionService")
	
--//
local assets = replicatedStorage.Assets
	local prefabs = assets.Prefabs
	local mobs = assets.Enemies
local players = {}	

local itemModule = require(assets.Modules.ItemModule)

local aiModule = {Acquire = nil}

--[!]--
--//NPC Generation
	--//Generates NPC Enemy
	function aiModule.generateEnemy(spawnPosition, tier)
		local enemies = itemModule.Enemies 
		local enemy = mobs[tier][aiModule.randomizeEnemies(tier)]:Clone()
		local location
		enemy:SetPrimaryPartCFrame(spawnPosition.CFrame * CFrame.new(0, 6, 0))
		for i, v in pairs(enemies[tier]) do
			if enemies[tier][i]["Name"] == enemy.Name then
				location = i
			end
		end
		aiModule.npcStats(tier, location, enemy)
		enemy.Parent = workspace.Gameplay.Enemies
		collectionService:AddTag(enemy, "Enemy") -- instanceSpawnModule will handle the rest
		
		enemy.Humanoid.Died:Connect(function()
			workspace.Gameplay.Holders.enemiesRemaining.Value = workspace.Gameplay.Holders.enemiesRemaining.Value - 1
		end)
	end
	
	--//Gets NPCs to Generate
	function aiModule.randomizeEnemies(tier)
		math.randomseed(tick()) 
		local enemies = itemModule.Enemies
		local totalTroops = 0
		--for i, v in pairs(enemies[tier]) do
	
		--end
		local troop = math.random(1, #mobs[tier]:GetChildren())--totalTroops)
	print("back to the sun"..tostring(troop).." "..tostring(#mobs[tier]:GetChildren()))
		return(enemies[tier][troop]["Name"])
	end
	
	--//Generate Spawn Locations
	function aiModule.spawnLocations(tier)
		local locations = workspace.Gameplay.Map:FindFirstChildWhichIsA("Model").Spawnables 
	 -- in the future change how the core spawns.. maybe with the map
		local numLocations = math.random(1, #locations:GetChildren())
		for i, v in pairs(locations:GetChildren()) do
			if i == numLocations then
				v.Material = "Neon"
				v.Color = Color3.fromRGB(255, 255, 255)
				aiModule.generateEnemy(v, tier)
				local decal = prefabs.Groundbreak:Clone()
				decal.Parent = v
				local spire = prefabs.Spire:Clone()
				spire.CFrame = v.CFrame * CFrame.new(0, 277.022 - 32, 0)
				spire.Parent = workspace.Gameplay
				game:GetService("Debris"):AddItem(spire,.5)
				--wait(0.5) 
				--spire:Destroy()
				v.Material = "Plastic"
				v.Color = Color3.fromRGB(91, 154, 76)
				spawn(function()
					for x = 0, 1, 0.01 do
						decal.Transparency = x
						wait()
					end
					decal:Destroy()
				end)
			end
		end
	end
	
	--//Random NPC Place Executer
	
	function aiModule.randomizeExecuter(low, high, tier) -- Variations for spawn
		local enemiesRemaining = workspace.Gameplay.Holders.enemiesRemaining
		local genNum = math.random(low, high)
		enemiesRemaining.Value = genNum
		local enemiesSpawned = 0
		for i = 1, genNum, 1 do
			if workspace.Gameplay.Holders.roundStatus.Value then
				local currentNum = genNum -- Helps variate tier
--				print(currentNum)
				genNum = math.random(low, high)
				aiModule.spawnLocations(tier)
				wait(1.5)
			else
				genNum = 0
				enemiesRemaining.Value = 0
			end
		end
	end

--[!]--
	--//NPC Stats Handler
	function aiModule.npcStats(tier, location, enemy)
		local enemies = itemModule.Enemies
		local round = workspace.Gameplay.Holders.round
		local damage = enemies[tier][location]["Damage"]
			local damageHolder = enemy.damage
		
		local chosen
		local notChosen
		local random = math.random(1, 100)
		if random >= 1 and random < 95 then
			chosen = "Coins"
			notChosen = "Diamonds"
		else
			chosen = "Diamonds"
			notChosen = "Coins"
		end
		
		local reward = enemies[tier][location]["Rewards"][chosen]
			local rewardHolder = enemy.reward[chosen]
			enemy.reward[notChosen]:Destroy()
		local health = enemies[tier][location]["Health"]
			local healthHolder = enemy.health
		local xp = enemies[tier][location]["XP"]
			local xpHolder = enemy.reward["xp"]
	
		if round.Value > 1 then
			damageHolder.Value = math.floor(damage + (damage * (0.5 * round.Value)))
			healthHolder.Value = math.floor(health + ((health * (0.6 * round.Value))))  -- health + ((health + (0.2 * round.Value)) (health + ((health ^ (0.5 * round.Value)) * 0.5)
			rewardHolder.Value = math.floor(reward + (reward * (0.3 * round.Value)))
			xpHolder.Value = math.floor(xp + (xp * (0.2 * round.Value)))
		else
			damageHolder.Value = damage
			rewardHolder.Value = reward
			healthHolder.Value = health
			xpHolder.Value = 10
		end
	end
	
	function aiModule.defenseKillTracker(playerObject,enemy) -- 
		local dataModule = aiModule.Acquire["DataModule"]
		local gamePassModule = aiModule.Acquire["GamePassModule"]
		local challengeModule = aiModule.Acquire["ChallengesModule"]
		local playerModule = aiModule.Acquire["PlayerModule"]
		
		local players = game:GetService("Players")
		local rewards = enemy.reward
		local xp = rewards["xp"]
		local currency
		if rewards:FindFirstChild("Diamonds") then
			currency = rewards["Diamonds"]
		else
			currency = rewards["Coins"]
		end
		
		
		--print("I like "..xp.Value.." xp and "..currency.Value.." "..currency.Name.. ":O")
		if playerObject then
			local playerFinder = game.Players:FindFirstChild(playerObject.Name)
			if playerFinder then
				dataModule.setData(playerFinder,"increment", "Kills", 1) 
				dataModule.setData(playerFinder, "increment", "XP", xp.Value)
				if currency.Name == "Coins" then
					if gamePassModule.playerHasPass(playerFinder, gamePassModule.gamePassIDs["10% More Cash"]) then
						local moreCoins = currency.Value + (currency.Value * .1)
						dataModule.setData(playerFinder, "increment", currency.Name, moreCoins)
					else
						dataModule.setData(playerFinder, "increment", currency.Name, currency.Value)
					end
				else
					dataModule.setData(playerFinder, "increment", currency.Name, currency.Value)
				end
				dataModule.levelSystem(playerFinder)
				playerModule.logCombat(playerFinder, "Kills", 1)
				playerModule.logCombat(playerFinder, "XpEarnt", xp.Value)
				challengeModule.killListener(playerFinder)
				
			end
		end
	end


return aiModule