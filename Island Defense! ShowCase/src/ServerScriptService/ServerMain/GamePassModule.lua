local gamePassModule = {Acquire = nil}
	gamePassModule.gamePassIDs = {["10% More Cash"] = 0000000}
	
	local MarketplaceService = game:GetService("MarketplaceService")

	gamePassModule.playerPurchaseActivateEffect = function(player,passID,purchaseSuccess)
		
		if purchaseSuccess then
			for passName,gamePassValue in pairs(gamePassModule.gamePassIDs) do
				if gamePassValue == passID then
					-- do gamepass effects here
				end
			end 
			--print(player.Name .. " purchased the game pass with ID " .. gamePassID)
			-- Assign this player the ability or bonus related to the game pass
			--
		end
	end
	gamePassModule.playerHasPass = function(player,gamePassID)
		local success, message = pcall(function()
			hasPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, gamePassID) 
		end)
	 
		if not success then
			warn("Error while checking if player has pass: " .. tostring(message))
			return
		end
	 
		if hasPass then
			return true
		else
			return false
		end
	end
	-- Function to handle a completed prompt and purchase
	
	-- Connect 'PromptGamePassPurchaseFinished' events to the 'onPromptGamePassPurchaseFinished()' function
	function gamePassModule:Init()
		MarketplaceService.PromptGamePassPurchaseFinished:Connect(gamePassModule.playerHasPass)
	end

return gamePassModule
