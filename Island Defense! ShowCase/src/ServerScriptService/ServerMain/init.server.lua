local Modules = {}
local descendants = script:getDescendants()

function getModules(children)
	for _,validDescendant in pairs(children) do
		if validDescendant:IsA("ModuleScript")  then
			Modules[validDescendant.Name] = require(validDescendant)
			--print(validDescendant.Name)
		end
	end
	for _,loader in pairs(Modules) do
		local success, err = pcall(function()
			loader.Acquire = Modules
			loader:Init()
		end)
	end
end
getModules(descendants) -- require all modules 



local version = 1
--//Services
	local replicatedStorage = game:GetService("ReplicatedStorage")
	local dataStoreService = game:GetService("DataStoreService")
	local CollectionService = game:GetService("CollectionService")
	local remotes = replicatedStorage.Assets.Remotes
		local afkEvent = remotes.AfkTick
--//Local Holders
	local assets = replicatedStorage:WaitForChild("Assets")
	
	local maps = {"Fallows", "Makuria", "Sharia"}
	local round = workspace.Gameplay.Holders.round
	local roundStatus = workspace.Gameplay.Holders.roundStatus
	local craftPositions = {}
	local players = {}
	local countdown = 600 -- Time to finish round
	local cooldown = 45 -- Round cooldowns

--//Modules
	local roundModule = Modules["RoundModule"]
	local playerModule = Modules["PlayerModule"]
--//Main	
--[!]--
	--//Leaderstats
local function onCharacterAdded(character)
	CollectionService:AddTag(character,"Target")
end
 
local function onCharacterRemoving(character)
	CollectionService:RemoveTag(character,"Target")
end


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
	
	
	wait(2.5)
	local dataModule = Modules["DataModule"]
	
	dataModule.getData(player, "Level")
	dataModule.getData(player, "XP")
	dataModule.getData(player, "Max XP")
	dataModule.getData(player, "Diamonds")
	dataModule.getData(player, "Coins")
	print("beep boop")

	Modules["ChallengesModule"].assignChallenges(player)
	Modules["DailyRewardModule"].giveReward(player)
end)
game.Players.PlayerRemoving:Connect(function(player)
	Modules["GamePassModule"].clearPlayerCache(player)
	Modules["PlayerModule"].removePlayerTables(player)
	Modules["ChallengesModule"].timeSpentListener(player)
end)

	afkEvent.OnServerEvent:Connect(function(player,bool)
		--print("make afk "..tostring(bool))
		Modules["PlayerModule"].makeAFK(player,bool)
	end)
	
	repeat 
		wait()
	until #game.Players:GetPlayers() == 1
	
	roundModule.startMatch()
	
