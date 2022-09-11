local dailyRewardModule = {Acquire = nil}
	local replicatedStorage = game:GetService("ReplicatedStorage")
		local displayDailyRewards = replicatedStorage.Assets.Remotes.DisplayDailyRewards
	local rewards = {	
		[1] = {"Coins", 250}, -- Day 1 and so on.
		[2] = {"Coins", 500},
		[3] = {"Coins", 750},
		[4] = {"Diamonds", 50},
		[5] = {"Diamonds", 100},
		[6] = {"Diamonds", 150},
		[7] = {"Diamonds", 200}
	}
	
	function dailyRewardModule.giveReward(player)
		local dataModule = dailyRewardModule.Acquire["DataModule"]
		local timeUntilReward = dataModule.findData(player, "Daily Challenge Timer")
		local claimedRewards = dataModule.findData(player, "Rewards Claimed Streak")
		local timeDifference = (os.difftime(os.time(),timeUntilReward)/3600)
		if claimedRewards == 0 then
	
			--fire client for rewards
			dataModule.setData(player, "increment", "Rewards Claimed Streak", 1)
			dataModule.setData(player, "change", "Daily Challenge Timer", os.time())
			claimedRewards = dataModule.findData(player, "Rewards Claimed Streak")
			print(claimedRewards.." : O")
			displayDailyRewards:FireClient(player,claimedRewards,rewards) -- player, reward to highlight, rest of the table
			dataModule.setData(player, "increment", rewards[claimedRewards][1], rewards[claimedRewards][2])
		elseif claimedRewards > 7 and timeDifference >= 24 then
			dataModule.setData(player, "change", "Rewards Claimed Streak", 1) -- back to day one
			dataModule.setData(player, "change", "Daily Challenge Timer", os.time())
			claimedRewards = dataModule.findData(player, "Rewards Claimed Streak")
			displayDailyRewards:FireClient(player,claimedRewards,rewards) -- player, reward to highlight, rest of the table
			dataModule.setData(player,"increment", rewards[claimedRewards][1], rewards[claimedRewards][2])
			
		elseif timeDifference >= 24 then
			dataModule.setData(player, "increment", "Rewards Claimed Streak", 1)
			dataModule.setData(player, "change", "Daily Challenge Timer", os.time())
			claimedRewards = dataModule.findData(player, "Rewards Claimed Streak")
			displayDailyRewards:FireClient(player,claimedRewards,rewards)
			dataModule.setData(player,"increment", rewards[claimedRewards][1], rewards[claimedRewards][2])
		end
	end
return dailyRewardModule
