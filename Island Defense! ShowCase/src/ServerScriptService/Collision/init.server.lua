--[[
	@Date: 4/1/2019

local version = 1
--//Services
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local dataStoreService = game:GetService("DataStoreService")
	local playerData = dataStoreService:GetDataStore("97841n1fn1f210201nc48")

--//Local Holders
	local assets = replicatedStorage:WaitForChild("Assets")

--//Modules
	--[[
	local aiModule = require(assets.Modules.AiModule)
	local dataModule = require(assets.Modules.DataModule)
		local itemModule = require(assets.Modules.DataModule.ItemModule)
	local playerModule = require(assets.Modules.PlayerModule)
	local roundModule = require(assets.Modules.RoundModule)
	local defenseModule = require(assets.Modules.DefenseModule)
	

--//
	local maps = {"Fallows", "Makuria", "Sharia"}
	local round = workspace.Gameplay.Holders.round
	local roundStatus = workspace.Gameplay.Holders.roundStatus
	local craftPositions = {}
	local players = {}
	local countdown = 600 -- Time to finish round
	local cooldown = 45 -- Round cooldowns

--//Main	
--[!]--
	--//Leaderstats
game.Players.PlayerAdded:Connect(function(player)
	wait()
	local leaderstats = Instance.new("Folder", player)
	leaderstats.Name = "leaderstats"
	
	local level = Instance.new("NumberValue", leaderstats)
	level.Name = "Level"
	
		local xp = Instance.new("NumberValue", player)
		xp.Name = "XP"
		
		local maxXP = Instance.new("NumberValue", player)
		maxXP.Name = "Max XP"
	
	local diamonds = Instance.new("NumberValue", leaderstats)
	diamonds.Name = "Diamonds"
	
	local coins = Instance.new("NumberValue", leaderstats)
	coins.Name = "Coins"
	
	
	wait(2)
	
	dataModule.getData(player, "Level")
		dataModule.getData(player, "XP")
		dataModule.getData(player, "Max XP")
	dataModule.getData(player, "Diamonds")
	dataModule.getData(player, "Coins")
	
	xp.Changed:Connect(function()
		dataModule.levelSystem(player)
	end)
	
	--//Location Spawn Test
--	roundModule.generateMap("Campfire")
--	wait(1)
--	workspace.Gameplay.Holders.roundStatus.Value = true
--	print("Round status value: true")
--	wait(10)
--	workspace.Gameplay.Holders.roundStatus.Value = false
--	print("Round status value: false")
	-- roundModule.generateWave()
	-- aiModule.randomizeExecuter(25, 35, "Tier 1")
end)
--[!]--
	--//Round Handler Test
	--roundModule.generateMap("Makuria")
	
--	if game.Players:GetPlayers() == 1 then
--		
--	end

	repeat 
		wait()
	until #game.Players:GetPlayers() == 1
	
	roundModule.generateMap()
	wait(5)
	playerModule.teleportAll("map")
	local holders = workspace.Gameplay.Holders
	
	roundModule.countdown("match", 90)
	roundStatus.Value = true
	round.Value = 1
	print(round.Value)
	
--	holders.enemiesRemaining.Value = 50
--	holders.roundTime.Value = 100
--	holders.roundStatus.Value = true
--	holders.round.Value = 50
--	wait(1)
--	workspace.Gameplay.Holders.roundStatus.Value = true
--	print("Round status value: true")
--	wait(10)
--	workspace.Gameplay.Holders.roundStatus.Value = false
--	print("Round status value: false")


--]]




