--[[
	@author: InTwoo,marcusc123
--]]
--//Services
local replicatedStorage = game:GetService("ReplicatedStorage")

--//workspace
local defenseGamePlay = workspace.Gameplay.Defenses
--//Services
local collectionService = game:GetService("CollectionService")
--//Holders
local currentMap = workspace.Gameplay.Holders.currentMap

--//
local assets = replicatedStorage.Assets
local prefabs = assets.Prefabs

--//Remotes
local confirmPlacement = assets.Remotes:WaitForChild("ToConfirmDefense")
local removePlacement = assets.Remotes:WaitForChild("ToRemoveDefense")
local tilePlacementTick = assets.Remotes:WaitForChild("TilePlacementTick")

local itemModule = require(assets.Modules.ItemModule)
-- local uiModule = require(assets.Modules.UIModule)


local defenseModule = {Acquire = nil}

function defenseModule.PlaceDefense(player, hexToPlaceOn, defenseToPlace)
	if player:DistanceFromCharacter(hexToPlaceOn.Position) <= 37 then
		local playerModule = defenseModule.Acquire["PlayerModule"]
		local dataModule = defenseModule.Acquire["DataModule"]
		local challengesModule = defenseModule.Acquire["ChallengesModule"]
		if not hexToPlaceOn.Scenery.Value and not hexToPlaceOn.Defense.Value then
			local turretCloneToPlace = assets.Defenses[defenseToPlace]:Clone()
			turretCloneToPlace:SetPrimaryPartCFrame(hexToPlaceOn.CFrame * CFrame.new(0, hexToPlaceOn.Size.Y/2, 0) * CFrame.new(0, turretCloneToPlace.Base.Base.Size.Y, 0))
			turretCloneToPlace.Health.Value = itemModule.Turrets[defenseToPlace]["MaxHealth"]
			turretCloneToPlace.MaxHealth.Value = itemModule.Turrets[defenseToPlace]["MaxHealth"]
			turretCloneToPlace.Parent = defenseGamePlay
			turretCloneToPlace.Hex.Value = hexToPlaceOn
			
			--dataModule.manipulateTable(player, "increment-key-value", "Owned Turrets", defenseToPlace, -1)	
			--dataModule.manipulateTable(player, "increment-key-value", "Placed Turrets", defenseToPlace, 1)	
			--dataModule.setData(player,"increment", "Number of Placed Turrets", 1)
						
			local playerTagger = turretCloneToPlace.playertag
			playerTagger.Value = player -- player.Name -- changed to ObjectValue
			
			hexToPlaceOn.Defense.Value = true
			collectionService:AddTag(turretCloneToPlace,"Turret")
			local position = turretCloneToPlace.PrimaryPart.CFrame
			playerModule.logCombat(player,"Turrets Placed",1)
			challengesModule.placeDownListener(player)
			spawn(function() playerModule.fireParticles("PlaceParticle", defenseToPlace, position) end)
			return true
		end
	end
	return false
end

function defenseModule.RemoveDefense(player,defenseToRemove)
	local dataModule = defenseModule.Acquire["DataModule"]
	local playerModule = defenseModule.Acquire["PlayerModule"]
	local challengesModule = defenseModule.Acquire["ChallengesModule"]
	if defenseToRemove and defenseToRemove:FindFirstChild("playertag") then
		print(defenseToRemove.playertag.Value == player,defenseToRemove.playertag.Value,player)
		if defenseToRemove.playertag.Value == player then -- player.Name
			if workspace.Gameplay.Map[currentMap.Value] then
				-- ask client are they sure they want to remove
				local descendants = workspace.Gameplay.Map[currentMap.Value].HexagonBase:GetDescendants()
				
				for _,hexagonFinder in pairs(descendants) do 
					if hexagonFinder == defenseToRemove.Hex.Value then
						hexagonFinder.Defense.Value = false
					end
				end
				--dataModule.manipulateTable(player, "increment-key-value", "Placed Turrets", defenseToRemove.Name, -1)
				local position = defenseToRemove.PrimaryPart.CFrame
				spawn(function() playerModule.fireParticles("DestroyParticle", defenseToRemove, position) end) -- has a wait dont want to yield server code
			
				-- defenseGamePlay:IsAncestorOf(defenseToRemove) then defenseToRemove:IsDecendantOf(defenseGamePlay)
				defenseToRemove:Destroy()
				challengesModule.destroyTurretListener(player)
				return true
			end
		end
		return false
	end
end


function defenseModule.RepairDefense(player,defenseToRepair)
	local purchaseComplete = false
	if defenseToRepair.playertag.Value == player.Name then
		--prompt player if they want to buy repair
		if purchaseComplete then
			local healthToRestore = defenseToRepair:FindFirstChild("Health")
			if healthToRestore then
				healthToRestore.Value = itemModule.Turrets[defenseToRepair]["MaxHealth"]
			end
		end
	end
end

--[[
confirmPlacement.OnServerEvent:Connect(function(player,hexagon,defensiveTurret)
	if player:DistanceFromCharacter(hexagon.Position) <= 37 then -- just in case there is mega delay from client we increase threshold 
		defenseModule.PlaceDefense(player,hexagon,defensiveTurret)
	end
end)
--]]

--[[
removePlacement.OnServerEvent:Connect(function(player,confirmRemovalOfDefense)
	defenseModule.RemoveDefense(player,confirmRemovalOfDefense)
end)
--]]

--[[
tilePlacementTick.OnServerEvent:Connect(function(player, tile, value)
	if player:DistanceFromCharacter(tile.Position) <= 37 then -- just in case there is mega delay from client we increase threshold 
		tile.Selected.Value = value
	end


	local sound = game.Workspace.Sounds.ClickTile:Clone()
	sound.Parent = tile
	sound:Play()
	wait(1)
	sound:Destroy()
	
end)
--]]


return defenseModule