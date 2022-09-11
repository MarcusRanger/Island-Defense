local challengesModule = {Acquire = nil}

--[[
	@author:marcusc123
--]]

--[[
			["Kills"] = 0,
			["Turret's Placed"] = 0,
			["Time Spent"] = 0,
--]]
-- if they have gamepass then this works
	local challengeGoals = {["Kills"] = 75, ["Turrets Placed"] = 50, ["Time Played"] = 8, ["Turrets Removed"] = 50} 
	local displayChallengeProgress = game:GetService("ReplicatedStorage").Assets.Remotes.DisplayChallengeProgress
	
	local function tickListener(player,valueName,valueTick)
		local dataModule = challengesModule.Acquire["DataModule"]

		if dataModule.findData(player,"Challenges")[valueName] then
			
			dataModule.manipulateTable(player, "increment-key-value", "Challenges", valueName, valueTick)
			local challengeValue = dataModule.findData(player, "Challenges")[valueName]
			displayChallengeProgress:FireClient(player, "update", valueName, challengeValue)
			challengesModule.checkCompleted(player, valueName, challengeValue)
		end
	end
	--make challenges 
	function challengesModule.assignChallenges(player)
		-- if player has gamepass then
		math.randomseed(tick())
		local duplicateRemoveChallengesArray = {}
		local dataModule = challengesModule.Acquire["DataModule"]
		local timeUntilReward = dataModule.findData(player, "Daily Challenge Timer")
		local timeDifference = (os.difftime(os.time(),timeUntilReward)/3600)
		--if timeDifference >= 24 then
			local num = 0
			for key, value in pairs(challengeGoals) do
				table.insert(duplicateRemoveChallengesArray, key)
			end
			dataModule.setData(player, "change", "Challenges", {}) -- resets challenges table
			repeat --  accounts duplicates 
				local randomChallengesIndex = math.random(#duplicateRemoveChallengesArray) -- get random index 
				local randomChallenges = duplicateRemoveChallengesArray[randomChallengesIndex] -- point to that index in array
				if randomChallenges == "Time Played" then
					dataModule.manipulateTable(player, "set-key-value", "Challenges", randomChallenges, os.time())
					displayChallengeProgress:FireClient(player, "create", randomChallenges)
				else
					dataModule.manipulateTable(player,"add-key-value", "Challenges", randomChallenges)
					displayChallengeProgress:FireClient(player, "create", randomChallenges)
				end
				table.remove(duplicateRemoveChallengesArray,randomChallengesIndex)-- use the same index to remove and repeat 
				num = num + 1
				wait()
			until num == 3
			
		--end
	end
	
	function challengesModule.killListener(player)
		tickListener(player,"Kills",1)
	end

	function challengesModule.placeDownListener(player)
		tickListener(player,"Turrets Placed",1)
	end
	
	function challengesModule.destroyTurretListener(player)
		tickListener(player,"Turrets Removed",1)
	end
	
	function challengesModule.roundsSurvivedListener()
		local players = game:GetService("Players")
		for i,player in pairs(players:GetPlayers()) do
			-- if they gamepass then
			tickListener(player,"Rounds Survived",1)
		end
	
	end
	
	function challengesModule.timeSpentListener(player)
		local dataModule = challengesModule.Acquire["DataModule"]
		local timer = dataModule.findData(player,"Challenges")["Time Played"] 
		if timer then
			local timeDifference = math.floor((os.difftime(os.time(),timer)/3600)) -- for single/tens digit display
			displayChallengeProgress:FireClient(player, "update", "Time Played", timeDifference)
			challengesModule.checkCompleted(player,"Time Played",timeDifference)
		end
	end
	
	function challengesModule.checkCompleted(player,challengeName,challengeValue)
		local challengeTracking = challengeGoals[challengeName]
		if challengeTracking then
			if challengeValue >= challengeTracking then
				challengesModule.challengeCompleted(player,challengeName)
				displayChallengeProgress:FireClient(player, "destroy", challengeName, challengeValue)
			end
		end
	end
	
	function challengesModule.challengeCompleted(player,challengeName)
		print("Im straight rida")
		local playerModule = challengesModule.Acquire["PlayerModule"]
		local dataModule = challengesModule.Acquire["DataModule"]
		dataModule.manipulateTable(player, "remove", "Challenges", challengeName)
		playerModule.grantRewards() --  does nothing right now
	end

-- Hook test
--game.Players.PlayerAdded:Connect(function(player)
--	while wait(0.2) do
--		challengesModule.killListener(player)
--	end
--end)

return challengesModule
