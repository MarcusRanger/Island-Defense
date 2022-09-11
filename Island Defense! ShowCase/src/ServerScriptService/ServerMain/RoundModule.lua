local roundModule = {Acquire = nil}
--[[
	@author: InTwoo,marcusc123
--]]
local replicatedStorage = game:GetService("ReplicatedStorage")
	local postRoundData = replicatedStorage.Assets.Remotes.DisplayPostRound
local holders = workspace.Gameplay.Holders
	local roundStatus = holders.roundStatus
	local roundNumber = holders.round
	local coreHealth = holders.coreHealth
	local intermissionStatus = holders.intermissionStatus

local intermissionTimer = 15
local beforeRoundIntermission = 10
local core = nil
local map = nil
local lastMap = nil
	local assets = replicatedStorage.Assets
		local prefabs = assets.Prefabs
			local hexagon = prefabs.Hexagon
		local maps = assets.Maps
		
	function roundModule.generateMap()-- it aint broke we keep it
		local success, err = pcall(function()
			local mapKey = math.random(1, #maps:GetChildren())
			local mapTable = {}
			
			for i, v in pairs(maps:GetChildren()) do
				table.insert(mapTable, v.Name)
			end
			
			-- local map = mapTable[mapKey]
			 map = mapTable[mapKey]--"Fallows"
			if workspace.Gameplay.Map:FindFirstChild(map) ~= nil then
				print(map.." already exists")
			else
				for i,v in pairs(workspace.Gameplay.Map:GetChildren()) do
					if v.Name ~= "Spawn" and v.Name ~= "Core" then
						v:Destroy()
					end
				end
				print("Map destroyed")
				local clone = maps[map]:Clone()
				clone.Parent = workspace.Gameplay.Map
				local currentMap = workspace.Gameplay.Holders.currentMap
				currentMap.Value = clone.Name
				print(map.." created")
			end
		end)
		
		if err then
			warn("roundModule.generateMap: "..err)
		end
	end
	
	function roundModule.generateWave() -- it aint broke we keep it

		local round = workspace.Gameplay.Holders.round.Value
		local tier
		local targetEnemies = 0
		print("generating wave") -- 
		local linearIncrease = (2*round) + 3
		local MobCap = math.clamp(linearIncrease,6,200)
		
		if MobCap < 20 then
			tier = "Tier 1" -- Tier 1
			
		elseif MobCap >= 20 and MobCap < 40 then
			tier = "Tier 2" -- Tier 2
			
		elseif MobCap >= 40 then
			tier = "Tier 3"
		end
		print(tier)
		roundModule.Acquire["AiModule"].randomizeExecuter(MobCap + 1, MobCap + 2, tier)
	end
	
	
	function roundModule.startMatch()
		local playerModule = roundModule.Acquire["PlayerModule"]
		roundModule.generateMap()
		playerModule.resetCombatLogs()
		wait(3)
		roundNumber.Value = 0
		roundStatus.Value = true
		coreHealth.Value = 100
		core = workspace.Gameplay.Map[map].Core
		intermissionStatus.Value = true
		for i = beforeRoundIntermission,0,-1 do -- Match Intermission
			workspace.Gameplay.Holders.intermission.Value = i
			wait(1)
			if i == 0 then
				intermissionStatus.Value = false
				--playerModule.teleportAll("map")
				roundModule.newRound()
			end
		end
	end
	
	function roundModule.endMatch() -- if it aint broke, tweek it a bit
		local playerModule = roundModule.Acquire["PlayerModule"]
		local dataModule = roundModule.Acquire["DataModule"]
		local challengesModule = roundModule.Acquire["ChallengesModule"]
		roundStatus.Value = false -- set false here just incase we dont call it from newRound
		--roundNumber.Value = 0
		
		playerModule.teleportAll("lobby")
		playerModule.grantRewards()
		
		for i, v in pairs(game.Players:GetPlayers()) do
			dataModule.softWipe(v.Name)
			challengesModule.timeSpentListener(v) -- dont know where else to put the timer listener honestly
		end
		
		for i, v in pairs(workspace.Gameplay.Map:GetChildren()) do
			if v:IsA("Model") then
				v:Destroy()
			end
		end
		
		for i, v in pairs(workspace.Gameplay.Enemies:GetChildren()) do
			local tagged = v:FindFirstChild("Tagged")
			if tagged then
				tagged:Destroy() -- dont want players getting kills by just tagging them after despawn
			end
			v:Destroy() -- instance spawn module cleans up the rest
		end
		
		for i,v in pairs(workspace.Gameplay.Defenses:GetChildren()) do
			v:Destroy() -- instance spawn module cleans up the rest
		end
		roundModule.startMatch()	
	end
	
	function roundModule.newRound()
		local playerModule = roundModule.Acquire["PlayerModule"]
		local challengesModule = roundModule.Acquire["ChallengesModule"]
		
		intermissionStatus.Value = true
		playerModule.teleportAll("map")
		playerModule.createLogs()
	for i = intermissionTimer,0,-1 do -- Round Intermission
			workspace.Gameplay.Holders.intermission.Value = i
			wait(1)
		end
		intermissionStatus.Value = false
		roundNumber.Value = roundNumber.Value + 1
		roundModule.generateWave() -- have to spawn function this in future
		repeat wait(1) until #workspace.Gameplay.Enemies:GetChildren() == 0 or not roundStatus.Value
		if not roundStatus.Value then
			roundModule.endMatch() -- mission failed we gettem a next time
		else
			challengesModule.roundsSurvivedListener()
			roundModule.endRound()
		end
	end
	
	function roundModule.endRound() -- I could of just called newRound again but maybe we want to reward player after everyround
		local playerModule = roundModule.Acquire["PlayerModule"]
		--player stuff maybe
		for _, player in pairs(game.Players:GetPlayers()) do
			 postRoundData:FireClient(player,playerModule.getCombatLog(player))
		end
		playerModule.resetCombatLogs()
		roundModule.newRound()
	end
	
	local defaultPosition = nil
	coreHealth.Changed:connect(function(health) -- visual flag
		--print(health)
		if core then
			if not defaultPosition then
				defaultPosition = core.Flag.Position
			end

			local Pole = core.Pole
			local Flag = core.Flag
			local flagBaseCalculation = defaultPosition - Vector3.new(0,(Pole.Size.Y - Flag.Size.Y), 0)
			
			Flag.Position = flagBaseCalculation + Vector3.new(0, ((health/100)*(Pole.Size.Y - Flag.Size.Y)), 0)
			
		end
		
		if health <= 0 then
--			roundModule.Acquire["PlayerModule"].teleportAll("lobby")
			roundStatus.Value = false
		end
	end)
		
return roundModule
