--[[
	@author: InTwoo
--]]

--local ReplicatedStorage = game.ReplicatedStorage
--local clientData = ReplicatedStorage.Assets.Remotes.ClientData

local playerModule = {Acquire = nil}

local AFKPlayers = {}
local CombatLog = {}
--//Teleport System
	function playerModule.teleportPlayer(type, player)
		if type == "lobby" then
			player.Character:MoveTo(workspace.Lobby.Spawns.Spawn.Position + Vector3.new(0, 6, 0))
		elseif type == "map" then
			player.Character:MoveTo(workspace.Gameplay.Map.Spawn.Position + Vector3.new(0, 6, 0))
		end
		print("Teleporting " .. player.Name .. " to " .. type)
	end
	
	function playerModule.teleportAll(type)
		if type == "lobby" then
			for i,players in pairs(game.Players:GetPlayers()) do
				if players.Character then
					players.Character:MoveTo(workspace.Lobby.Spawns.Spawn.Position + Vector3.new(0, 20, 0)) -- changed this for now
				end
			end
		elseif type == "map" then
			for i,players in pairs(game.Players:GetPlayers()) do
				if players.Character and not AFKPlayers[players] then
					players.Character:MoveTo(workspace.Gameplay.Map.Spawn.Position + Vector3.new(0, 20, 0))
				end
			end
		else
			warn("playerModule.teleportAll: ".. type .." does not exist")
		end
		print("Teleporting all to " .. type)
	end
	
--//Level System
--[[
	function playerModule.levelHandler(player) 
		local dataModule = playerModule.Acquire["DataModule"]
		print("ON THAT MOUNTAINTOP GETTING MOUNTAIN TOP!")
		local level = dataModule.findData(player, "Level")
		local xp = dataModule.findData(player, "XP")
		local maxXP = dataModule.findData(player, "Max XP")
		print(xp,maxXP," little bitch thats a knock out")
		if xp >= maxXP then
			print("I STILL GET RACKS!")
			dataModule.setData(player, "increment", "Level", 1)
			print("Player Level'd up!", level)
			dataModule.setData(player, "change", "Max XP", maxXP + (maxXP * (level * (maxXP ^ 1.45))))
			maxXP = dataModule.findData(player, "Max XP")
			print("Max XP: ", maxXP)
		end
	end
--]]

	function playerModule.grantRewards()
		--
	end
	
	--//Post Round Stat Handle
	function playerModule.createLogs()
		for _,player in pairs(game.Players:GetPlayers()) do
			if not CombatLog[player] then 
				CombatLog[player] = {["Kills"] = 0, ["Turrets Placed"] = 0,["XpEarnt"] = 0}
			end
		end
	end
	function playerModule.logCombat(player,type,value)
		if not CombatLog[player] then -- just in case they didnt get it from createLogs()
			CombatLog[player] = {["Kills"] = 0, ["Turrets Placed"] = 0}
		end
		if type == "Kills" then
			CombatLog[player]["Kills"] = CombatLog[player]["Kills"] + value
		elseif type == "Turrets Placed" then
			CombatLog[player]["Turrets Placed"] = CombatLog[player]["Turrets Placed"] + value
		elseif type == "XpEarnt" then
			CombatLog[player]["XpEarnt"] = CombatLog[player]["XpEarnt"] + value
		end
	end
	
	function playerModule.resetCombatLogs()
		CombatLog = {}
	end
	
	function playerModule.getCombatLog(player)
		if CombatLog[player] then
			return CombatLog[player]
		end
	end
	
	function playerModule.rewardCombat()
		
	end
	
	--//Afk
	function playerModule.makeAFK(player,bool) -- forgot that i needed to finish this
		if player and bool then
			AFKPlayers[player] = true
		else
			AFKPlayers[player] = false
		end
	end
	
	function playerModule.checkAFK(player) -- just incase we check in an other module
		if AFKPlayers[player] then
			return true
		else
			return false
		end
	end
	
	function playerModule.removePlayerTables(player) -- when player leaves the game
		AFKPlayers[player] = nil
		CombatLog[player] = nil
	end
	
--//Particle
	function playerModule.fireParticles(particle,defense,position)
		local clonedParticle = game:GetService("ReplicatedStorage").Assets.Particles[particle]:Clone()
		clonedParticle.Parent = workspace
		clonedParticle:SetPrimaryPartCFrame(position)
		wait(3)
		clonedParticle:Destroy()
	end
	
--//Weapon
local equipWeapon = game:GetService("ReplicatedStorage").Assets.Remotes.EquipWeapon
	equipWeapon.OnServerEvent:Connect(function(player, type, weapon) --secure this
		local dataModule = playerModule.Acquire["DataModule"]
		if type == "equip" and dataModule.tableSearch(dataModule.findData(player, "Owned Weapons"), "detect", weapon.Name) then -- without this check clients can just equip any weapon
			print("Equipping")
			local clone = weapon:Clone()
			clone.Parent = player.Backpack
			player.Character.Humanoid:EquipTool(clone)
		elseif type == "unequip" then
			print("Unequipping")
			--player.Character.Humanoid:UnequipTools() --adds back to backpack which calls the child added function, dont want that
			local checkTool = player.Character:FindFirstChild(weapon)
			if checkTool then
				checkTool:Destroy()
			end
		end
	end)
return playerModule