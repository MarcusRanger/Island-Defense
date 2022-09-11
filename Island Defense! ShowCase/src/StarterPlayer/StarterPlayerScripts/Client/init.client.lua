--[[
	@Author: InTwoo,marcusc123
--]]
-- script.Parent.ScreenUI.Enabled = true
wait(2)
local replicatedStorage = game:GetService("ReplicatedStorage")
	--local clientData = replicatedStorage.Assets.Remotes.ClientData
	--local purchaseCheck = replicatedStorage.Assets.Remotes.PurchaseCheck
	local postRoundData = replicatedStorage.Assets.Remotes.DisplayPostRound
	local dailyRewardData = replicatedStorage.Assets.Remotes.DisplayDailyRewards
local holders = workspace.Gameplay.Holders

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local updateTopNav = {holders.round,holders.intermission,holders.enemiesRemaining}

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

getModules(descendants)
--[[
for i,v in pairs(Modules) do
	local success, err = pcall(function()
	--	v:Init()
	end)
	if err then
		--print(i.." doesnt have Init!")
	end
end
--]]

Modules["TurretPlaceDown"].setUpDefenseButtons()
local interfaceModule = Modules["InterfaceModule"]

for _,holderValue in pairs(updateTopNav) do
	holderValue.Changed:Connect(function()
		interfaceModule.topNAVUpdate()
	end)
end


if updateTopNav[1].Value == true then -- if player joins but doesnt switch nav through changed event
	interfaceModule.topNAVSwitch(false)
elseif updateTopNav[2].Value == true then
	interfaceModule.topNAVSwitch(true)
end


holders.intermissionStatus.Changed:Connect(function(value)
	print("oh yea..")
	interfaceModule.topNAVSwitch(value)
end)

postRoundData.OnClientEvent:Connect(function(postRoundTable)
	if postRoundTable then
		interfaceModule.postUIShow(true)
		interfaceModule.postUIStats(postRoundTable)
		wait(5) -- uhh...
		interfaceModule.postUIShow(false)
	end
end)

dailyRewardData.OnClientEvent:Connect(function(highlightReward,rewardTable)
	if highlightReward and rewardTable then
		interfaceModule.displayRewards(highlightReward,rewardTable)
	end
end)



--[!]--
	--//Turrets
	
--[!]--
	--//PurchaseCheck Remote
	
	
--[!]--