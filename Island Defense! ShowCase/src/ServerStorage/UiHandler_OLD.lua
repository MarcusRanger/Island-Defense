local uiHandler = {Acquire = nil}
local player = game:GetService("Players").LocalPlayer
local mouse = player:GetMouse()

local replicatedStorage = game:GetService("ReplicatedStorage")
	local assets = replicatedStorage.Assets
	local modules = assets.Modules
		local itemModule = require(modules.ItemModule)
			-- local playerModule = require(modules.PlayerModule)
			-- local dataModule = require(modules.DataModule)
	local crates = assets.Crates
	local defensePreviews = assets.DefensePreviews
	local effects = assets.Effects
	local enemies = assets.Enemies
	local maps = assets.Maps
	local weapons = assets.Weapons
	local remotes = assets.Remotes
		local clientData = remotes.ClientData
		local dataEvent = remotes.DataEvents
		local purchaseCheck = remotes.PurchaseCheck
		local displayChallengeProgress = remotes.DisplayChallengeProgress

local starterGui = game:GetService("StarterGui")

--//HUDS
	local ScreenUI = player.PlayerGui:WaitForChild("ScreenUI")
	local placeHUD = ScreenUI.PlaceHUD
	local timeHUD = ScreenUI.TimeHUD
	local levelHUD = ScreenUI.LeveHUD
	local currencyHUD = ScreenUI.CurrencyHUD
	local outroundHUD = ScreenUI.Outround
	local teleport = ScreenUI.Teleport
	local promptHUD = ScreenUI.PromptHUD

--//Holders
	local holder = workspace.Gameplay.Holders
		local map = holder.currentMap
		local enemiesRemaining = holder.enemiesRemaining
		local intermission = holder.intermission
		local round = holder.round
		local roundStatus = holder.roundStatus

local uiModule = require(modules.UIModule)

--//Loaders
	--//Functions
	local function requestLevelData()
		local data = clientData:InvokeServer("returnData")
		local level = player.leaderstats.Level.Value
		local xp = player["XP"].Value
		local maxXP = player["Max XP"].Value
		
		levelHUD.Holder.ActivatedHud.LevelFrame.LevelHolder.LevelText.Text = tostring(level)
		levelHUD.Holder.ActivatedHud.FillerShadow.FillerHolder.BarHolder.XPLabel.Text = tostring(xp) .."/".. tostring(maxXP)
		levelHUD.Holder.ActivatedHud.FillerShadow.FillerHolder.BarHolder.Filler:TweenSizeAndPosition(UDim2.new(1, 0, xp/maxXP, 0), UDim2.new(0, 0, 1-(xp/maxXP), 0), "Out", "Quart", 0.2, true)
	end
	
	--//Statements
	placeHUD.Holder.ActivatedHud.Position = uiModule.Placements.PlaceHUD.Holder.ActivatedHud["Tween Position"]
	levelHUD.Holder.ActivatedHud.Position = uiModule.Placements.LevelHUD.Holder.ActivatedHud["Tween Position"]
	promptHUD.Holder.Position = uiModule.Placements.PromptHUD.Holder["Tween Position"]
	
	for i, v in pairs(outroundHUD.HUDButtons:GetChildren()) do
		v.Position = uiModule.Placements.Outround.HUDButtons[tostring(v)]["Original Round Position"]
	end

	timeHUD.Holder.PlaceHudShadow.PlaceHudHolder.Timer.TextLabel.Text = "0:00"
	timeHUD.Holder.PlaceHudShadow.PlaceHudHolder.Round.TextLabel.Text = round.Value
	timeHUD.Holder.PlaceHudShadow.PlaceHudHolder.EnemiesRemaining.TextLabel.Text = enemiesRemaining.Value
	
	uiModule.requestTurretClientData()
	
	requestLevelData()
	
	currencyHUD.Holder.CoinsShadow.CoinsHolder.CoinsText.Text = player.leaderstats.Coins.Value
	currencyHUD.Holder.DiamondsShadow.DiamondsHolder.DiamondsText.Text = player.leaderstats.Diamonds.Value

--//Changes
	round.Changed:Connect(function()
		if round.Value > 0 then
			timeHUD.Holder.PlaceHudShadow.PlaceHudHolder.Round.TextLabel.Text = tostring(round.Value)
		else
			timeHUD.Holder.PlaceHudShadow.PlaceHudHolder.Round.TextLabel.Text = "-"
		end
	end)
	
	enemiesRemaining.Changed:Connect(function()
		if enemiesRemaining.Value > 0 then
			timeHUD.Holder.PlaceHudShadow.PlaceHudHolder.EnemiesRemaining.TextLabel.Text = tostring(enemiesRemaining.Value)
		else
			timeHUD.Holder.PlaceHudShadow.PlaceHudHolder.EnemiesRemaining.TextLabel.Text = "-"
		end
	end)

	intermission.Changed:Connect(function()
		if intermission.Value >= 0 then
			local minutes = math.floor(intermission.Value / 60)
			local seconds = intermission.Value - (60 * minutes)
			if seconds > 9 then
				timeHUD.Holder.PlaceHudShadow.PlaceHudHolder.Timer.TextLabel.Text = tostring(minutes) .. ":" .. tostring(seconds)
			else
				timeHUD.Holder.PlaceHudShadow.PlaceHudHolder.Timer.TextLabel.Text = tostring(minutes) .. ":0" .. tostring(seconds)
			end
		end
	end)
	
--//Turret Health Handler
	workspace.Gameplay.Defenses.DescendantAdded:Connect(function(child)
		if child.Name == "Healthbar" then
			child.Parent.Health.Changed:Connect(function()
				child.HPGui.HealthText = child.Parent.Health.Value .. "/" .. child.Parent.MaxHealth.Value
				child.HPGui.Health:TweenSize(UDim2.new(child.Parent.Health.Value / child.Parent.MaxHealth.Value, 0, 1, 0, "Out", "Quart", 0.1, true))
			end)
		end
	end)
	
--//Currency Handler
	player.leaderstats.Coins.Changed:Connect(function()
		currencyHUD.Holder.CoinsShadow.CoinsHolder.CoinsText.Text = player.leaderstats.Coins.Value
		uiModule.requestTurretClientData()
	end)
	
	player.leaderstats.Diamonds.Changed:Connect(function()
		currencyHUD.Holder.DiamondsShadow.DiamondsHolder.DiamondsText.Text = player.leaderstats.Diamonds.Value
		uiModule.requestTurretClientData()
	end)
promptHUD.Holder.Content.PurchaseHolder.CoinsHolder.CoinsPurchase.MouseButton1Click:Connect(function()
	local turretPlaceDown = uiHandler.Acquire["TurretPlaceDown"]
	local check
	
	if promptHUD.Holder.TextHolder.PurchaseType.Text == "Purchase" and turretPlaceDown.currentHexToPlaceOn  then
		check = purchaseCheck:InvokeServer("purchaseTurret", "Coins", turretPlaceDown.currentlyPlacingTurret, turretPlaceDown.currentHexToPlaceOn)
		uiModule.promptUser(player, "removeUI", "Turrets", turretPlaceDown.currentlyPlacingTurret)
		if check then
			uiModule.screenAlert(player, "transaction completed", "Transaction Successful!")
			turretPlaceDown.removeHighlights()
			turretPlaceDown.confirmingPurchase = false
			uiModule.requestTurretClientData()
		else
			uiModule.screenAlert(player, "transaction failed", "Transaction Failed: Insufficient Coins!")
			turretPlaceDown.removeHighlights()
			turretPlaceDown.confirmingPurchase = false
			uiModule.requestTurretClientData()
				
		end
	end
	if promptHUD.Holder.TextHolder.PurchaseType.Text == "Destroy" then
		promptHUD.Holder:TweenPosition(uiModule.Placements.PromptHUD.Holder["Tween Position"], "Out", "Quart", 0.2, true)
		check = purchaseCheck:InvokeServer("destroyTurret", "Coins", turretPlaceDown.mainTurretFromPart)
		uiModule.promptUser(player, "removeUI", "Turrets", turretPlaceDown.mainTurretFromPart.Name)
		if check then
			uiModule.screenAlert(player, "transaction completed", "Successfully Destroyed: Defense Destroyed!!")
		end
	end
end)
			
promptHUD.Holder.Content.PurchaseHolder.DiamondsHolder.DiamondsPurchase.MouseButton1Click:Connect(function()
	local turretPlaceDown = uiHandler.Acquire["TurretPlaceDown"]
	local check
	
	local value = uiModule.returnTurretCost(turretPlaceDown.currentlyPlacingTurret, "returnDiamonds")
	
	if promptHUD.Holder.TextHolder.PurchaseType.Text == "Purchase" and turretPlaceDown.currentHexToPlaceOn then
		check = purchaseCheck:InvokeServer("purchaseTurret", "Diamonds", turretPlaceDown.currentlyPlacingTurret, turretPlaceDown.currentHexToPlaceOn)
		uiModule.promptUser(player, "removeUI", "Turrets", turretPlaceDown.currentlyPlacingTurret)
		if check then
			uiModule.screenAlert(player, "transaction completed", "Transaction Successful!")
			turretPlaceDown.removeHighlights()
			turretPlaceDown.confirmingPurchase = false
			uiModule.requestTurretClientData()

		else
			uiModule.screenAlert(player, "transaction failed", "Transaction Failed: Insufficient Diamonds!")
			turretPlaceDown.removeHighlights()
			turretPlaceDown.confirmingPurchase = false
			uiModule.requestTurretClientData()
		
		end
	end
end)

promptHUD.Holder.Content.Filler.Cancel.MouseButton1Click:Connect(function()
	local turretPlaceDown = uiHandler.Acquire["TurretPlaceDown"]
	turretPlaceDown.removeHighlights()
	turretPlaceDown.confirmingPurchase = false
end)	

	
--//Place HUD Animations Handler
placeHUD.Holder.MaximizeMovement.NavigationButton.MouseButton1Click:Connect(function()
	placeHUD.Holder.ActivatedHud:TweenPosition(uiModule.Placements.PlaceHUD.Holder.ActivatedHud["Original Position"], "Out", "Bounce", 0.5, true)
	levelHUD.Holder.MaximizeMovement:TweenPosition(uiModule.Placements.LevelHUD.Holder.MaximizeMovement["Tween Position"], "Out", "Quint", 0.2, true)
	placeHUD.Holder.MaximizeMovement:TweenPosition(uiModule.Placements.PlaceHUD.Holder.MaximizeMovement["Tween Position"], "Out", "Quint", 0.2, true)
	timeHUD.Holder:TweenPosition(UDim2.new(0.3, 0, -0.15, 0), "Out", "Quint", 0.5, true)
	for i, v in pairs(outroundHUD.HUDButtons:GetChildren()) do
		v:TweenPosition(uiModule.Placements.Outround.HUDButtons[tostring(v)]["Tween Round Position"], "Out", "Quint", 0.2, true)
	end
end)

placeHUD.Holder.ActivatedHud.MinimizeMovement.NavigationButton.MouseButton1Click:Connect(function()
	local turretPlaceDown = uiHandler.Acquire["TurretPlaceDown"]
	turretPlaceDown.removeHighlights()
	turretPlaceDown.confirmingPurchase = false
	placeHUD.Holder.ActivatedHud:TweenPosition(uiModule.Placements.PlaceHUD.Holder.ActivatedHud["Tween Position"], "Out", "Quint", 0.5, true)
	levelHUD.Holder.MaximizeMovement:TweenPosition(uiModule.Placements.LevelHUD.Holder.MaximizeMovement["Original Position"], "Out", "Bounce", 0.5, true)
	placeHUD.Holder.MaximizeMovement:TweenPosition(uiModule.Placements.PlaceHUD.Holder.MaximizeMovement["Original Position"], "Out", "Bounce", 0.5, true)
	timeHUD.Holder:TweenPosition(UDim2.new(0.3, 0, 0, 0), "Out", "Bounce", 0.5, true)
	for i, v in pairs(outroundHUD.HUDButtons:GetChildren()) do
		v:TweenPosition(uiModule.Placements.Outround.HUDButtons[tostring(v)]["Original Round Position"], "Out", "Bounce", 0.5, true)
	end
end)

--//Turret Number Handler
	player.leaderstats.Coins.Changed:Connect(function()
		local ownedTurrets = clientData:InvokeServer("returnData")
		
		for i, v in pairs(placeHUD.Holder.ActivatedHud.PlaceHudShadow.PlaceHudHolder.Defenses:GetChildren()) do
			if ownedTurrets["Owned Turrets"][v.Name] ~= nil then
				if ownedTurrets["Owned Turrets"][v.Name] == 0 then
					placeHUD.Holder.ActivatedHud.PlaceHudShadow.PlaceHudHolder.Defenses[v.Name].Place.SpotAmount.ImageColor3 = Color3.fromRGB(247, 24, 24)
				else
					placeHUD.Holder.ActivatedHud.PlaceHudShadow.PlaceHudHolder.Defenses[v.Name].Place.SpotAmount.ImageColor3 = Color3.fromRGB(34, 247, 124)
				end
				placeHUD.Holder.ActivatedHud.PlaceHudShadow.PlaceHudHolder.Defenses[v.Name].Place.SpotAmount.Amount.Text = tostring(ownedTurrets["Owned Turrets"][v.Name])
			end
		end
	end)
--[!]--
--//Place HUD Viewport
local placeHUDViewPort = placeHUD.Holder.ActivatedHud.PlaceHudShadow.PlaceHudHolder.Defenses
	for i, v in pairs(placeHUDViewPort:GetChildren()) do
		if v.ViewportFrame:FindFirstChild(v.Name) ~= nil then
			uiModule.placeHUDViewport(v)
		end
	end

return uiHandler