local purchaseService = {Acquire = nil}

	local MarketplaceService = game:GetService("MarketplaceService")
	local PurchaseHistory = game:GetService("DataStoreService"):GetDataStore("PurchaseHistory")
	 
	--[[
		This is how the table below has to be set up:
			[productId] = function(receipt,player) return allow end
				receipt is the receiptInfo, as called by ProcessReceipt
				player is the player that is doing the purchase
			If your function returns 'true', the purchase is approved.
			If your function doesn't return 'true', or errors, the purchase is cancelled.
	--]]
	
	local Products = {
		
		[593425579] = function(receipt,player)
			--print("AHHHHHHHHHHHHH, YOUTH!!!!!")
			local dataModule = purchaseService.Acquire["DataModule"]
			local findCurrency = dataModule.findData(player, "Diamonds") 
			if findCurrency then
				dataModule.setData(player, "increment", "Diamonds", 2500)
			else
				return
			end
			return true
		end; -- set up the rest SoonTM
	
	}
	 
	
	function MarketplaceService.ProcessReceipt(receiptInfo) 
	    local playerProductKey = receiptInfo.PlayerId .. ":" .. receiptInfo.PurchaseId
	    if PurchaseHistory:GetAsync(playerProductKey) then
	        return Enum.ProductPurchaseDecision.PurchaseGranted 
	    end
	   
		local player = game:GetService("Players"):GetPlayerByUserId(receiptInfo.PlayerId)
		if not player then return Enum.ProductPurchaseDecision.NotProcessedYet end
		
	 
		local handler
		for productId,func in pairs(Products) do
			if productId == receiptInfo.ProductId then
				handler = func break 
			end
		end
	 
		
		if not handler then return Enum.ProductPurchaseDecision.PurchaseGranted end
	 
	
		local suc,err = pcall(handler,receiptInfo,player)
		if not suc then
			warn("An error occured while processing a product purchase")
			print("\t ProductId:",receiptInfo.ProductId)
			print("\t Player:",player)
			print("\t Error message:",err) -- log it to the output
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
	 
		if not err then
			return Enum.ProductPurchaseDecision.NotProcessedYet
		end
	 
	  
	    suc,err = pcall(function()
	        PurchaseHistory:SetAsync(playerProductKey, true)
	    end)
	    if not suc then
	        print("An error occured while saving a product purchase")
			print("\t ProductId:",receiptInfo.ProductId)
			print("\t Player:",player)
			print("\t Error message:",err) -- log it to the output
			print("\t Handler worked fine, purchase granted") -- add a small note that the actual purchase has succeed
	    end
	
	    return Enum.ProductPurchaseDecision.PurchaseGranted		
	end
return purchaseService