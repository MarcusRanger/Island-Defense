local interfaceModule = {Acquire = nil}
		
--//Services
local replicatedStorage = game:GetService("ReplicatedStorage")
local soundService = game:GetService("SoundService")
local tweenService = game:GetService("TweenService")
local marketplaceService = game:GetService("MarketplaceService")

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera
	--//Interface
	local mainGui = player.PlayerGui:WaitForChild("MainUI")
		local currencyHUD = mainGui.CurrencyHUD
		local currencyShopHUD = mainGui.CurrencyShopHUD
		local leftnav = mainGui.LeftNAV
		local placeHUD = mainGui.PlaceHUD
		local promptHUD = mainGui.PromptHUD
		local questHUD = mainGui.QuestHUD
		local weaponHUD = mainGui.WeaponHUD
		local settingsHUD = mainGui.SettingsHUD
		local topnav = mainGui.TopNAV
		local spectateHUD = mainGui.SpectateHUD
		local shopHUD = mainGui.ShopHUD
		local weaponDisplay = mainGui.WeaponDisplay
		local afkAlert = mainGui.AFKAlert
	local postroundGui = player.PlayerGui:WaitForChild("PostRoundUI")
		local levelHUD = postroundGui.LevelHUD
		local rewardsHolder = postroundGui.RewardsHolder
		local statsHolder = postroundGui.StatsHolder
	local dailyRewards = player.PlayerGui:WaitForChild("DailyRewards")
	local weaponsSurface = player.PlayerGui.PurchaseWeapon
		
--//Variable Holders
local assets = replicatedStorage:WaitForChild("Assets")
	local modules = assets.Modules
		local itemModule = require(modules.ItemModule)
--		local uiModule = require(modules.UIModule)
		local crates = assets.Crates
	local defensePreviews = assets.DefensePreviews
	local effects = assets.Effects
	local enemies = assets.Enemies
	local maps = assets.Maps
	local weapons = assets.Weapons
	local remotes = assets.Remotes
		local clientData = remotes.ClientData
		local dataEvent = remotes.DataEvents
		local afkEvent = remotes.AfkTick
		local purchaseCheck = remotes.PurchaseCheck
		local displayChallengeProgress = remotes.DisplayChallengeProgress
		local equipWeapon = remotes.EquipWeapon

--local turretPlaceDown = require(script.Parent.TurretPlaceDown)
--local effectsModule = require(script.Parent["TwooEffectsPackage-v1"].Assets.EffectsModule)
local tweenInfo = TweenInfo.new(
	0.2,
	Enum.EasingStyle.Quart,
	Enum.EasingDirection.Out
)

--//Workspace Holders
	local holder = workspace.Gameplay.Holders
		local map = holder.currentMap
		local enemiesRemaining = holder.enemiesRemaining
		local intermission = holder.intermission
		local round = holder.round
		local roundStatus = holder.roundStatus
--//Lighting
	local blurEffect = game.Lighting.Blur

--//Functions
	function interfaceModule.changeTheme(theme)
		--[[
			Themes: light, dark
		--]]
		
		--//LeftNAV
		for _, element in pairs(leftnav:GetChildren()) do
			if element:IsA("ImageLabel") then
				if theme == "light" then
					tweenService:Create(element, tweenInfo, {ImageColor3 = Color3.fromRGB(220, 220, 220)}):Play()
					tweenService:Create(element.Filler, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
					tweenService:Create(element.Filler.Label, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
				elseif theme == "dark" then
					tweenService:Create(element, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
					tweenService:Create(element.Filler, tweenInfo, {ImageColor3 = Color3.fromRGB(44, 62, 80)}):Play()
					tweenService:Create(element.Filler.Label, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				end
			end
		end
		
		--//PlaceHUD
		local activatedHUD = placeHUD.ActivatedHUD
		if theme == "light" then
			tweenService:Create(activatedHUD.LeftMovement, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(activatedHUD.RightMovement, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(activatedHUD.LeftMovement.NavigationButton, tweenInfo, {ImageColor3 = Color3.fromRGB(122, 122, 122)}):Play()
			tweenService:Create(activatedHUD.RightMovement.NavigationButton, tweenInfo, {ImageColor3 = Color3.fromRGB(122, 122, 122)}):Play()
			tweenService:Create(activatedHUD.PlaceHudShadow, tweenInfo, {ImageColor3 = Color3.fromRGB(220, 220, 220)}):Play()
			tweenService:Create(activatedHUD.PlaceHudShadow.LimitShadow, tweenInfo, {ImageColor3 = Color3.fromRGB(220, 220, 220)}):Play()
			tweenService:Create(activatedHUD.PlaceHudShadow.LimitShadow.LimitFiller, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(activatedHUD.PlaceHudShadow.LimitShadow.LimitFiller.PlaceAmount, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
			tweenService:Create(activatedHUD.PlaceHudShadow.PlaceHudHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(placeHUD.MaximizeMovement, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(placeHUD.MaximizeMovement.NavigationButton, tweenInfo, {ImageColor3 = Color3.fromRGB(122, 122, 122)}):Play()
--			for i, slot in pairs(activatedHUD.PlaceHudShadow.PlaceHudHolder.Defenses:GetChildren()) do
--				tweenService:Create(slot, tweenInfo, {ImageColor3 = Color3.fromRGB(215, 215, 215)}):Play()
--			end
		elseif theme == "dark" then
			tweenService:Create(activatedHUD.LeftMovement, tweenInfo, {ImageColor3 = Color3.fromRGB(44, 62, 80)}):Play()
			tweenService:Create(activatedHUD.RightMovement, tweenInfo, {ImageColor3 = Color3.fromRGB(44, 62, 80)}):Play()
			tweenService:Create(activatedHUD.LeftMovement.NavigationButton, tweenInfo, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			tweenService:Create(activatedHUD.RightMovement.NavigationButton, tweenInfo, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			tweenService:Create(activatedHUD.PlaceHudShadow, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(activatedHUD.PlaceHudShadow.LimitShadow, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(activatedHUD.PlaceHudShadow.LimitShadow.LimitFiller, tweenInfo, {ImageColor3 = Color3.fromRGB(44, 62, 80)}):Play()
			tweenService:Create(activatedHUD.PlaceHudShadow.LimitShadow.LimitFiller.PlaceAmount, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			tweenService:Create(activatedHUD.PlaceHudShadow.PlaceHudHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(44, 62, 80)}):Play()
			tweenService:Create(placeHUD.MaximizeMovement, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(placeHUD.MaximizeMovement.NavigationButton, tweenInfo, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
--			for i, slot in pairs(activatedHUD.PlaceHudShadow.PlaceHudHolder.Defenses:GetChildren()) do
--				tweenService:Create(slot, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
--			end
		end
		
		--//PromptHUD
		if theme == "light" then
			promptHUD.ContentHolder.BackgroundColor3 = Color3.fromRGB(243, 243, 243)
			promptHUD.BottomBack.ImageColor3 = Color3.fromRGB(243, 243, 243)
			promptHUD.TopBack.ImageColor3 = Color3.fromRGB(243, 243, 243)
			promptHUD.TitleHolder.Title.TextColor3 = Color3.fromRGB(122, 122, 122)
			promptHUD.ContentHolder.Context.TextColor3 = Color3.fromRGB(122, 122, 122)
			promptHUD.ContentHolder.BottomBorder.BackgroundColor3 = Color3.fromRGB(122, 122, 122)
			promptHUD.ContentHolder.TopBorder.BackgroundColor3 = Color3.fromRGB(122, 122, 122)
			promptHUD.ContentHolder.CoinsHolder.ImageColor3 = Color3.fromRGB(215, 215, 215)
			promptHUD.ContentHolder.DiamondsHolder.ImageColor3 = Color3.fromRGB(215, 215, 215)
			promptHUD.ContentHolder.CoinsHolder.Amount.TextColor3 = Color3.fromRGB(122, 122, 122)
			promptHUD.ContentHolder.DiamondsHolder.Amount.TextColor3 = Color3.fromRGB(122, 122, 122)
		elseif theme == "dark" then
			promptHUD.ContentHolder.BackgroundColor3 = Color3.fromRGB(52, 73, 94)
			promptHUD.BottomBack.ImageColor3 = Color3.fromRGB(52, 73, 94)
			promptHUD.TopBack.ImageColor3 = Color3.fromRGB(52, 73, 94)
			promptHUD.TitleHolder.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
			promptHUD.ContentHolder.Context.TextColor3 = Color3.fromRGB(255, 255, 255)
			promptHUD.ContentHolder.BottomBorder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			promptHUD.ContentHolder.TopBorder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			promptHUD.ContentHolder.CoinsHolder.ImageColor3 = Color3.fromRGB(44, 62, 80)
			promptHUD.ContentHolder.DiamondsHolder.ImageColor3 = Color3.fromRGB(44, 62, 80)
			promptHUD.ContentHolder.CoinsHolder.Amount.TextColor3 = Color3.fromRGB(255, 255, 255)
			promptHUD.ContentHolder.DiamondsHolder.Amount.TextColor3 = Color3.fromRGB(255, 255, 255)
		end
		
		--//QuestHUD
		local questTemplate = assets.Template.QuestTemplate
		if theme == "light" then
			tweenService:Create(questHUD.ContentHolder, tweenInfo, {BackgroundColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(questHUD.BottomBack, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(questHUD.TopBack, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(questHUD.TitleHolder.Title, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
			
			tweenService:Create(questTemplate.ProgressHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(215, 215, 215)}):Play()
			tweenService:Create(questTemplate.RewardHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(215, 215, 215)}):Play()
			tweenService:Create(questTemplate.ProgressHolder.Goal, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
			tweenService:Create(questTemplate.ProgressHolder.Info, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
			tweenService:Create(questTemplate.RewardHolder.Info, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
			
			for i, quests in pairs(questHUD.ContentHolder.ScrollingFrame:GetChildren()) do
				if quests:IsA("Frame") then
					tweenService:Create(quests.ProgressHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(215, 215, 215)}):Play()
					tweenService:Create(quests.RewardHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(215, 215, 215)}):Play()
					tweenService:Create(quests.ProgressHolder.Goal, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
					tweenService:Create(quests.ProgressHolder.Info, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
					tweenService:Create(quests.RewardHolder.Info, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
				end
			end
		elseif theme == "dark" then
			tweenService:Create(questHUD.ContentHolder, tweenInfo, {BackgroundColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(questHUD.BottomBack, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(questHUD.TopBack, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(questHUD.TitleHolder.Title, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			
			tweenService:Create(questTemplate.ProgressHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(44, 62, 80)}):Play()
			tweenService:Create(questTemplate.RewardHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(44, 62, 80)}):Play()
			tweenService:Create(questTemplate.ProgressHolder.Goal, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			tweenService:Create(questTemplate.ProgressHolder.Info, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			tweenService:Create(questTemplate.RewardHolder.Info, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			
			for i, quests in pairs(questHUD.ContentHolder.ScrollingFrame:GetChildren()) do
				if quests:IsA("Frame") then
					tweenService:Create(quests.ProgressHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(44, 62, 80)}):Play()
					tweenService:Create(quests.RewardHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(44, 62, 80)}):Play()
					tweenService:Create(quests.ProgressHolder.Goal, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
					tweenService:Create(quests.ProgressHolder.Info, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
					tweenService:Create(quests.RewardHolder.Info, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				end
			end
		end
		
		--//SettingsHUD
		if theme == "light" then
			tweenService:Create(settingsHUD.ContentHolder, tweenInfo, {BackgroundColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(settingsHUD.BottomBack, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(settingsHUD.TopBack, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(settingsHUD.TitleHolder.Title, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
			tweenService:Create(settingsHUD.ContentHolder.Themes.Title, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
		elseif theme == "dark" then
			tweenService:Create(settingsHUD.ContentHolder, tweenInfo, {BackgroundColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(settingsHUD.BottomBack, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(settingsHUD.TopBack, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(settingsHUD.TitleHolder.Title, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			tweenService:Create(settingsHUD.ContentHolder.Themes.Title, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end
		
		--//TopNAV
		if theme == "light" then
			for i, text in pairs(topnav:GetChildren()) do
				if text:IsA("Frame") then
					tweenService:Create(text.Label, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
					tweenService:Create(text.Title, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
				end
			end
		elseif theme == "dark" then
			for i, text in pairs(topnav:GetChildren()) do
				if text:IsA("Frame") then
					tweenService:Create(text.Label, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
					tweenService:Create(text.Title, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				end
			end
		end
		
		--//SpectateHUD
		if theme == "light" then
			tweenService:Create(spectateHUD.NameHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(spectateHUD.LeftMovement, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(spectateHUD.RightMovement, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(spectateHUD.NameHolder.PlayerName, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
			tweenService:Create(spectateHUD.LeftMovement.NavigationButton, tweenInfo, {ImageColor3 = Color3.fromRGB(122, 122, 122)}):Play()
			tweenService:Create(spectateHUD.RightMovement.NavigationButton, tweenInfo, {ImageColor3 = Color3.fromRGB(122, 122, 122)}):Play()
		elseif theme == "dark" then
			tweenService:Create(spectateHUD.NameHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(44, 62, 80)}):Play()
			tweenService:Create(spectateHUD.LeftMovement, tweenInfo, {ImageColor3 = Color3.fromRGB(44, 62, 80)}):Play()
			tweenService:Create(spectateHUD.RightMovement, tweenInfo, {ImageColor3 = Color3.fromRGB(44, 62, 80)}):Play()
			tweenService:Create(spectateHUD.NameHolder.PlayerName, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			tweenService:Create(spectateHUD.LeftMovement.NavigationButton, tweenInfo, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			tweenService:Create(spectateHUD.RightMovement.NavigationButton, tweenInfo, {ImageColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end
		
		--//ShopHUD
		if theme == "light" then
			tweenService:Create(shopHUD.ContentHolder, tweenInfo, {BackgroundColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(shopHUD.BottomBack, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(shopHUD.TopBack, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(shopHUD.TitleHolder.Title, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
			tweenService:Create(shopHUD.ContentHolder.ProductCaption, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
			tweenService:Create(shopHUD.ContentHolder.PassCaption, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
			for i, v in pairs(shopHUD.ContentHolder.Products:GetChildren()) do
				if v:IsA("ImageLabel") then
					tweenService:Create(v.ProductName, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
					tweenService:Create(v.Price, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
				end
			end
			
			for i, v in pairs(shopHUD.ContentHolder.Passes:GetChildren()) do
				if v:IsA("ImageLabel") then
					tweenService:Create(v.ProductName, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
					tweenService:Create(v.Price, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
				end
			end
		elseif theme == "dark" then
			tweenService:Create(shopHUD.ContentHolder, tweenInfo, {BackgroundColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(shopHUD.BottomBack, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(shopHUD.TopBack, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(shopHUD.TitleHolder.Title, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			tweenService:Create(shopHUD.ContentHolder.ProductCaption, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			tweenService:Create(shopHUD.ContentHolder.PassCaption, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			for i, v in pairs(shopHUD.ContentHolder.Products:GetChildren()) do
				if v:IsA("ImageLabel") then
					tweenService:Create(v.ProductName, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
					tweenService:Create(v.Price, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				end
			end
			
			for i, v in pairs(shopHUD.ContentHolder.Passes:GetChildren()) do
				if v:IsA("ImageLabel") then
					tweenService:Create(v.ProductName, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
					tweenService:Create(v.Price, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				end
			end
		end
		
		--//Currency Shop
		if theme == "light" then
			tweenService:Create(currencyShopHUD.BottomBack, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(currencyShopHUD.TopBack, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(currencyShopHUD.ContentHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(currencyShopHUD.ContentHolder.Currency, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
			for i, v in pairs(currencyShopHUD.ContentHolder.ProductHolder:GetChildren()) do
				if v:IsA("Frame") then
					tweenService:Create(v.Amount, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				end
			end
			tweenService:Create(assets.Template.CurrencyTemplate.Amount, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
		elseif theme == "dark" then
			tweenService:Create(currencyShopHUD.BottomBack, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(currencyShopHUD.TopBack, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(currencyShopHUD.ContentHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(currencyShopHUD.ContentHolder.Currency, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			for i, v in pairs(currencyShopHUD.ContentHolder.ProductHolder:GetChildren()) do
				if v:IsA("Frame") then
					tweenService:Create(v.Amount, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				end
			end
			tweenService:Create(assets.Template.CurrencyTemplate.Amount, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end
		
		--//Weapon Display
		if theme == "light" then
			tweenService:Create(weaponDisplay.WeaponsHolderShadow, tweenInfo, {ImageColor3 = Color3.fromRGB(220, 220, 220)}):Play()
			tweenService:Create(weaponDisplay.WeaponsHolderFiller, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
		elseif theme == "dark" then
			tweenService:Create(weaponDisplay.WeaponsHolderShadow, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(weaponDisplay.WeaponsHolderShadow.WeaponsHolderFiller, tweenInfo, {ImageColor3 = Color3.fromRGB(44, 62, 80)}):Play()
		end
		
		--//WeaponsHUD
		if theme == "light" then
			tweenService:Create(weaponHUD.TopBack, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(weaponHUD.BottomBack, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(weaponHUD.ContentHolder, tweenInfo, {BackgroundColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(weaponHUD.TitleHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(243, 243, 243)}):Play()
			tweenService:Create(weaponHUD.TitleHolder.Title, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
			for i, v in pairs(weaponHUD.ContentHolder.ScrollingFrame:GetChildren()) do
				if v:IsA("Frame") then
					tweenService:Create(v.WeaponName, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
					tweenService:Create(v.Purchase.ClaimButton, tweenInfo, {TextColor3 = Color3.fromRGB(122, 122, 122)}):Play()
				end
			end
		elseif theme == "dark" then
			tweenService:Create(weaponHUD.TopBack, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(weaponHUD.BottomBack, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(weaponHUD.ContentHolder, tweenInfo, {BackgroundColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(weaponHUD.TitleHolder, tweenInfo, {ImageColor3 = Color3.fromRGB(52, 73, 94)}):Play()
			tweenService:Create(weaponHUD.TitleHolder.Title, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			for i, v in pairs(weaponHUD.ContentHolder.ScrollingFrame:GetChildren()) do
				if v:IsA("Frame") then
					tweenService:Create(v.WeaponName, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
					tweenService:Create(v.Purchase.ClaimButton, tweenInfo, {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				end
			end
		end
	end
	
	function interfaceModule.resetInterface()
		currencyHUD:TweenPosition(UDim2.new(0, 0, 0.84, 0), "Out", "Quart", 0.2)
		currencyShopHUD:TweenPosition(UDim2.new(-0.6, 0, 0.25, 0), "Out", "Quart", 0.2)
		leftnav:TweenPosition(UDim2.new(-0.002, 0, 0.35, 0), "Out", "Quart", 0.2)
		placeHUD.ActivatedHUD:TweenPosition(UDim2.new(0, 0, 1.1, 0), "Out", "Quart", 0.2)
		placeHUD.Visible = true
		promptHUD:TweenPosition(UDim2.new(0.35, 0, -0.8, 0), "Out", "Quart", 0.2)
		questHUD:TweenPosition(UDim2.new(1.1, 0, 0.5, 0), "Out", "Quart", 0.2)
		settingsHUD:TweenPosition(UDim2.new(0.35, 0, -0.6, 0), "Out", "Quart", 0.2)
		topnav:TweenPosition(UDim2.new(0.4, 0, 0.007, 0), "Out", "Quart", 0.2)
		spectateHUD:TweenPosition(UDim2.new(0.15, 0, 1.1, 0), "Out", "Quart", 0.2)
		shopHUD:TweenPosition(UDim2.new(-0.5, 0, 0.25, 0), "Out", "Quart", 0.2)
		weaponDisplay:TweenPosition(UDim2.new(0.86, 0, 0.85, 0), "Out", "Quart", 0.2)
		weaponHUD:TweenPosition(UDim2.new(-0.5, 0, 0.3, 0), "Out", "Quart", 0.2)
	end
	
	function interfaceModule.hideElements()
		local turretPlaceDown = interfaceModule.Acquire["TurretPlaceDown"]
		currencyHUD:TweenPosition(UDim2.new(-0.5, 0, 0.84, 0), "Out", "Quart", 0.2)
		currencyShopHUD:TweenPosition(UDim2.new(-0.6, 0, 0.25, 0), "Out", "Quart", 0.2)
		leftnav:TweenPosition(UDim2.new(-0.5, 0, 0.35, 0), "Out", "Quart", 0.2)
		placeHUD.ActivatedHUD:TweenPosition(UDim2.new(0, 0, 1.3, 0), "Out", "Quart", 0.2)
		placeHUD.Visible = false
		promptHUD:TweenPosition(UDim2.new(0.35, 0, -0.8, 0), "Out", "Quart", 0.2)
		questHUD:TweenPosition(UDim2.new(1.1, 0, 0.5, 0), "Out", "Quart", 0.2)
		settingsHUD:TweenPosition(UDim2.new(0.35, 0, -0.6, 0), "Out", "Quart", 0.2)
		topnav:TweenPosition(UDim2.new(0.4, 0, -0.3, 0), "Out", "Quart", 0.2)
		spectateHUD:TweenPosition(UDim2.new(0.15, 0, 1.1, 0), "Out", "Quart", 0.2)
		shopHUD:TweenPosition(UDim2.new(-0.5, 0, 0.25, 0), "Out", "Quart", 0.2)
		weaponDisplay:TweenPosition(UDim2.new(1, 0, 0.85, 0), "Out", "Quart", 0.2)
		weaponHUD:TweenPosition(UDim2.new(-0.5, 0, 0.3, 0), "Out", "Quart", 0.2)
		turretPlaceDown.removeHighlights() -- this is just incase the player is placing down a turret when the post Ui screen is up
		turretPlaceDown.currentlyPlacingTurret = nil
		turretPlaceDown.confirmingPurchase = false
	end
	
	function interfaceModule.showElements()
		
	end
	
	function interfaceModule.activateElement()
		
	end
	
	function interfaceModule.deactivateElement()
		
	end

--//Loaders
	--//Functions
	function interfaceModule.requestLevelData(gainedXP)
		local data = clientData:InvokeServer("returnData")
		local level = data["Level"]--player.leaderstats.Level.Value
		
		local xp = data["XP"]--player["XP"].Value
		local maxXP = data["Max XP"]--player["Max XP"].Value
		
		levelHUD.ActivatedHud.LevelFrame.LevelHolder.LevelText.Text = tostring(level)
		levelHUD.ActivatedHud.FillerShadow.XPLabel.Text = tostring(xp) .."/".. tostring(maxXP)
		--levelHUD.ActivatedHud.FillerShadow.FillerHolder.Filler:TweenSizeAndPosition(UDim2.new(1, 0, xp/maxXP, 0), UDim2.new(0, 0, 1-(xp/maxXP), 0), "Out", "Quart", 0.2, true)
		levelHUD.ActivatedHud.FillerShadow.FillerHolder.Filler:TweenSize(UDim2.new(xp/maxXP, 0, 1, 0), "Out", "Quart", 0.2, true)
		levelHUD.ActivatedHud.FillerShadow.XPEarnt.Text = "+"..tostring(gainedXP)
	end
	
	--//Turret Data
	function interfaceModule.requestTurretClientData()
		local limitText = placeHUD.ActivatedHUD.PlaceHudShadow.LimitShadow.LimitFiller.PlaceAmount
		local playerData = clientData:InvokeServer("returnData")
		
		for i, v in pairs(placeHUD.ActivatedHUD.PlaceHudShadow.PlaceHudHolder.Defenses:GetChildren()) do
			if playerData["Owned Turrets"][v.Name] ~= nil then
				if playerData["Owned Turrets"][v.Name] == 0 then
					placeHUD.ActivatedHUD.PlaceHudShadow.PlaceHudHolder.Defenses[v.Name].Place.SpotAmount.ImageColor3 = Color3.fromRGB(247, 24, 24)
				else
					placeHUD.ActivatedHUD.PlaceHudShadow.PlaceHudHolder.Defenses[v.Name].Place.SpotAmount.ImageColor3 = Color3.fromRGB(34, 247, 124)
				end
				placeHUD.ActivatedHUD.PlaceHudShadow.PlaceHudHolder.Defenses[v.Name].Place.SpotAmount.Amount.Text = tostring(playerData["Owned Turrets"][v.Name])
			end
		end
		limitText.Text = tostring(playerData["Number of Placed Turrets"]) .. "/" .. tostring(playerData["Turret Limit"])
	end
	
	function interfaceModule.requestTurretCost(turret, amount)
		local itemModule = require(game:GetService("ReplicatedStorage").Assets.Modules.ItemModule)
			
		if promptHUD.TextHolder.PurchaseType.Text == "Purchase" then
			local coinCost = itemModule.Turrets[turret]["Coins"] + (amount * 80)
			local diamondCost = itemModule.Turrets[turret]["Diamonds"] + (amount * 25)
			promptHUD.ContentHolder.CoinsHolder.Amount.Text = tostring(coinCost)
			promptHUD.ContentHolder.DiamondsHolder.Amount.Text = tostring(diamondCost)
		elseif promptHUD.TextHolder.PurchaseType.Text == "Destroy" then
			local coinCost = (itemModule.Turrets[turret]["Coins"]) * 0.45
			promptHUD.ContentHolder.CoinsHolder.Amount.Text = tostring(coinCost)
		end
	end
	
	local function loadCurrencies()
		wait(3)
		local playerData = clientData:InvokeServer("returnData")
		currencyHUD.CoinsShadow.CoinsHolder.CoinsText.Text = tostring(playerData["Coins"])
		currencyHUD.DiamondsShadow.DiamondsHolder.DiamondsText.Text = tostring(playerData["Diamonds"])
	end
	
	spawn(loadCurrencies)
	--//Returns Turret Cost
	function interfaceModule.returnTurretCost(turret, type)
		local playerData = clientData:InvokeServer("returnData")
		
		local amount
		local coinCost
		local diamondCost
		
		amount = playerData["Purchased Turrets"][turret]
		
		if promptHUD.TitleHolder.Title.Text == "Purchase" then
			coinCost = itemModule.Turrets[turret]["Coins"] + (amount * 80)
			diamondCost = itemModule.Turrets[turret]["Diamonds"] + (amount * 25)
			promptHUD.ContentHolder.CoinsHolder.Amount.Text = tostring(coinCost)
			promptHUD.ContentHolder.DiamondsHolder.Amount.Text = tostring(diamondCost)
		elseif promptHUD.TitleHolder.Title.Text == "Destroy" then
			coinCost = (itemModule.Turrets[turret]["Coins"]) * 0.45
			promptHUD.Content.PurchaseHolder.CoinsHolder.Amount.Text = tostring(coinCost)
		end
		
		if type == "returnCoins" then
			return coinCost
		elseif type == "returnDiamonds" then
			return diamondCost
		end
	end
	
	--//Turret viewport
	function interfaceModule.placeHUDViewport(object)
		--//Viewport Handler
		local runService = game:GetService("RunService")
		local target = game:GetService("ReplicatedStorage").Assets.Defenses[object.Name]:Clone()
		target.Parent = object.ViewportFrame
		local camera = Instance.new("Camera")
		object.ViewportFrame.CurrentCamera = camera
		
		camera.CFrame = CFrame.new(Vector3.new(target:SetPrimaryPartCFrame(CFrame.new(0, -2, 0))))
		camera.CFrame = CFrame.new(Vector3.new(0, 0, 10), target.PrimaryPart.Position)
		
		runService.Heartbeat:Connect(function()
			if target.PrimaryPart then
				target:SetPrimaryPartCFrame(target.PrimaryPart.CFrame * CFrame.Angles(0, -math.rad(1), 0))
			end
		end)
	end
	
--	currencyHUD.CoinsShadow.CoinsHolder.CoinsText.Text = player.leaderstats.Coins.Value
--	currencyHUD.DiamondsShadow.DiamondsHolder.DiamondsText.Text = player.leaderstats.Diamonds.Value

	--//PostUI

	function interfaceModule.postUIShow(visibleValue)
		local cloneBlurEffect = blurEffect:Clone()
		if visibleValue then
			cloneBlurEffect.Enabled = true
			cloneBlurEffect.Parent = camera
			interfaceModule.hideElements()
			postroundGui.Enabled = visibleValue
			game:GetService("Debris"):AddItem(cloneBlurEffect,5)
		else 
			interfaceModule.resetInterface()
			postroundGui.Enabled = visibleValue
		end
	end
	--rewardsholder visible is ticked off for now
	function interfaceModule.postUIStats(statsTable)
		interfaceModule.requestLevelData(statsTable["XpEarnt"])
		for i,v in pairs(statsHolder:GetChildren()) do
			if not v:IsA("UIGridLayout") then
				v:Destroy()
			end
		end
		for statName,statValue in pairs(statsTable) do
			local template = assets.Template.RoundRewardTemplate:Clone()
			if statName == "Kills" then
				template.Category.Text = "Enemies Killed:"
				template.Earnings.Text = "x"..statValue
				template.Parent = statsHolder
				
			elseif statName == "Turrets Placed" then
				template.Category.Text = "Turrets Placed:"
				template.Earnings.Text = "x"..statValue
				template.Parent = statsHolder
			end
		end		
	end
	
	--//DailyRewardsUi
	function interfaceModule.displayRewards(showReward,rewardTable)
		dailyRewards.Enabled = true
		for rewardName,rewardValue in pairs(rewardTable) do
			local template = assets.Template.DailyRewardTemplate:Clone()
			if rewardName ~= showReward then
				template.RewardIconCoin.ImageColor3 = Color3.fromRGB(0,0,0)
			end
			if rewardValue[1] == "Coins" then
				template.RewardIconCoin.Visible = true
				template.RewardIconDiamond.Visible = false
				template.Reward.TextColor3 = Color3.fromRGB(252, 255, 48)
				template.Reward.Text = rewardValue[2]
				template.Day.Text = "Day "..rewardName
			elseif rewardValue[1] == "Diamonds" then
				template.RewardIconCoin.Visible = false
				template.RewardIconDiamond.Visible = true
				template.Reward.TextColor3 = Color3.fromRGB(21, 185, 255)
				template.Reward.Text = rewardValue[2]
				template.Day.Text = "Day "..rewardName
			end
			template.Parent = dailyRewards.DailyRewardsHUD.ContentHolder.RewardsHolder
		end	
	end
	dailyRewards.DailyRewardsHUD.Claim.ClaimButton.MouseButton1Click:Connect(function()
		--prompt ui here
		interfaceModule.screenAlert(player, "transaction completed", "Reward Claimed!")
		dailyRewards.Enabled = false
	end)
	--21, 185, 255 for blue 
	--252, 255, 48 for yellow
	--//TopNav
	function interfaceModule.topNAVUpdate()
		topnav.TimeHolder.Title.Text = intermission.Value
		topnav.EnemiesHolder.Title.Text = enemiesRemaining.Value
		topnav.RoundHolder.Title.Text = round.Value
	end
	
	function interfaceModule.topNAVSwitch(inIntermission)
		--print(tostring(inIntermission).." slol")
		if inIntermission then
			topnav.EnemiesHolder.Visible = false
			topnav.RoundHolder.Visible = false
			topnav.TimeHolder.Visible = true
		else
			topnav.EnemiesHolder.Visible = true
			topnav.RoundHolder.Visible = true
			topnav.TimeHolder.Visible = false
		end	
	end
--//Main
	--//Show Turrets Owned
	interfaceModule.requestTurretClientData()
	--//Audio
	for _, descendant in pairs(mainGui:GetDescendants()) do
		if descendant:IsA("ImageButton") or descendant:IsA("TextButton") then
			descendant.MouseButton1Click:Connect(function()
				soundService.InterfaceClick:Play()
			end)
		end
	end
--[!]--	

	
	--//LeftNAV
		--//Quests
	leftnav.QuestsShadow.Filler.Label.MouseButton1Click:Connect(function()
		if questHUD.Position ~= UDim2.new(0.695, 0, 0.5, 0) then
			questHUD:TweenPosition(UDim2.new(0.695, 0, 0.5, 0), "Out", "Quart", 0.2)
		else
			questHUD:TweenPosition(UDim2.new(1.1, 0, 0.5, 0), "Out", "Quart", 0.2)
		end
	end)
		--//AFK
	local playerAFK = false
	leftnav.AFKShadow.Filler.Label.MouseButton1Click:Connect(function()
		playerAFK = not playerAFK
		if not playerAFK then
		 	afkAlert.Visible = false
		else
			afkAlert.Visible = true
		end
		afkEvent:FireServer(playerAFK)
	end)
		--//Settings
	leftnav.SettingsShadow.Filler.Label.MouseButton1Click:Connect(function()
		
		currencyHUD:TweenPosition(UDim2.new(0, 0, 0.84, 0), "Out", "Quart", 0.2)
		currencyShopHUD:TweenPosition(UDim2.new(-0.6, 0, 0.25, 0), "Out", "Quart", 0.2)
		placeHUD.ActivatedHUD:TweenPosition(UDim2.new(0, 0, 1.1, 0), "Out", "Quart", 0.2)
		promptHUD:TweenPosition(UDim2.new(0.35, 0, -0.8, 0), "Out", "Quart", 0.2)
		topnav:TweenPosition(UDim2.new(0.4, 0, 0.007, 0), "Out", "Quart", 0.2)
		spectateHUD:TweenPosition(UDim2.new(0.15, 0, 1.1, 0), "Out", "Quart", 0.2)
		shopHUD:TweenPosition(UDim2.new(-0.5, 0, 0.25, 0), "Out", "Quart", 0.2)
		weaponDisplay:TweenPosition(UDim2.new(0.86, 0, 0.85, 0), "Out", "Quart", 0.2)
		weaponHUD:TweenPosition(UDim2.new(-0.5, 0, 0.3, 0), "Out", "Quart", 0.2)
		
		if settingsHUD.Position ~= UDim2.new(0.35, 0, 0.25, 0) then
			settingsHUD:TweenPosition(UDim2.new(0.35, 0, 0.25, 0), "Out", "Quart", 0.2)
		else
			settingsHUD:TweenPosition(UDim2.new(0.35, 0, -0.6, 0), "Out", "Quart", 0.2)
		end
	end)
	
		--//Weapons	
	leftnav.WeaponsShadow.Filler.Label.MouseButton1Click:Connect(function()
		
		currencyHUD:TweenPosition(UDim2.new(0, 0, 0.84, 0), "Out", "Quart", 0.2)
		currencyShopHUD:TweenPosition(UDim2.new(-0.6, 0, 0.25, 0), "Out", "Quart", 0.2)
		placeHUD.ActivatedHUD:TweenPosition(UDim2.new(0, 0, 1.1, 0), "Out", "Quart", 0.2)
		promptHUD:TweenPosition(UDim2.new(0.35, 0, -0.8, 0), "Out", "Quart", 0.2)
		settingsHUD:TweenPosition(UDim2.new(0.35, 0, -0.6, 0), "Out", "Quart", 0.2)
		topnav:TweenPosition(UDim2.new(0.4, 0, 0.007, 0), "Out", "Quart", 0.2)
		spectateHUD:TweenPosition(UDim2.new(0.15, 0, 1.1, 0), "Out", "Quart", 0.2)
		shopHUD:TweenPosition(UDim2.new(-0.5, 0, 0.25, 0), "Out", "Quart", 0.2)
		weaponDisplay:TweenPosition(UDim2.new(0.86, 0, 0.85, 0), "Out", "Quart", 0.2)
		
		if weaponHUD.Position ~= UDim2.new(0.375, 0, 0.3, 0) then
			weaponHUD:TweenPosition(UDim2.new(0.375, 0, 0.3, 0), "Out", "Quart", 0.2)
		else
			weaponHUD:TweenPosition(UDim2.new(-0.5, 0, 0.3, 0), "Out", "Quart", 0.2)
		end
	end)
	
	weaponHUD.Cancel.CancelButton.MouseButton1Click:Connect(function()
		weaponHUD:TweenPosition(UDim2.new(-0.5, 0, 0.3, 0), "Out", "Quart", 0.2)
	end)
	
	settingsHUD.Cancel.CancelButton.MouseButton1Click:Connect(function()
		settingsHUD:TweenPosition(UDim2.new(0.35, 0, -0.6, 0), "Out", "Quart", 0.2)
	end)
		--//Spectate
	leftnav.SpectateShadow.Filler.Label.MouseButton1Click:Connect(function()
		
		leftnav:TweenPosition(UDim2.new(-0.5, 0, 0.35, 0), "Out", "Quart", 0.2)
		currencyHUD:TweenPosition(UDim2.new(0, 0, 0.84, 0), "Out", "Quart", 0.2)
		currencyShopHUD:TweenPosition(UDim2.new(-0.6, 0, 0.25, 0), "Out", "Quart", 0.2)
		placeHUD.ActivatedHUD:TweenPosition(UDim2.new(0, 0, 1.1, 0), "Out", "Quart", 0.2)
		promptHUD:TweenPosition(UDim2.new(0.35, 0, -0.8, 0), "Out", "Quart", 0.2)
		settingsHUD:TweenPosition(UDim2.new(0.35, 0, -0.6, 0), "Out", "Quart", 0.2)
		topnav:TweenPosition(UDim2.new(0.4, 0, 0.007, 0), "Out", "Quart", 0.2)
		shopHUD:TweenPosition(UDim2.new(-0.5, 0, 0.25, 0), "Out", "Quart", 0.2)
		weaponDisplay:TweenPosition(UDim2.new(0.86, 0, 0.85, 0), "Out", "Quart", 0.2)
		weaponHUD:TweenPosition(UDim2.new(-0.5, 0, 0.3, 0), "Out", "Quart", 0.2)
		
		local camera = interfaceModule.Acquire["Camera"]
		if spectateHUD.Position == UDim2.new(0.15, 0, 0.84, 0) then
			spectateHUD:TweenPosition(UDim2.new(0.15, 0, 1.1, 0), "Out", "Quart", 0.2)
			camera.originalSubject()
			spawn(interfaceModule.resetInterface)
		else
			spectateHUD:TweenPosition(UDim2.new(0.15, 0, 0.84, 0), "Out", "Quart", 0.2)
			spawn(interfaceModule.resetInterface)
		end
	end)
	
	spectateHUD.LeftMovement.NavigationButton.MouseButton1Click:Connect(function()
		local camera = interfaceModule.Acquire["Camera"]
		spectateHUD.NameHolder.PlayerName.Text = camera.spectateNextPlayer()
	end)
	
	spectateHUD.RightMovement.NavigationButton.MouseButton1Click:Connect(function()
		local camera = interfaceModule.Acquire["Camera"]
		spectateHUD.NameHolder.PlayerName.Text = camera.spectatePreviousPlayer()
	end)
	
	spectateHUD.Cancel.CancelButton.MouseButton1Click:Connect(function()
		local camera = interfaceModule.Acquire["Camera"]
		camera.originalSubject()
		interfaceModule.resetInterface()
	end)
		--//Shop
	leftnav.ShopShadow.Filler.Label.MouseButton1Click:Connect(function()
		
		currencyHUD:TweenPosition(UDim2.new(0, 0, 0.84, 0), "Out", "Quart", 0.2)
		currencyShopHUD:TweenPosition(UDim2.new(-0.6, 0, 0.25, 0), "Out", "Quart", 0.2)
		placeHUD.ActivatedHUD:TweenPosition(UDim2.new(0, 0, 1.1, 0), "Out", "Quart", 0.2)
		promptHUD:TweenPosition(UDim2.new(0.35, 0, -0.8, 0), "Out", "Quart", 0.2)
		questHUD:TweenPosition(UDim2.new(1.1, 0, 0.5, 0), "Out", "Quart", 0.2)
		settingsHUD:TweenPosition(UDim2.new(0.35, 0, -0.6, 0), "Out", "Quart", 0.2)
		topnav:TweenPosition(UDim2.new(0.4, 0, 0.007, 0), "Out", "Quart", 0.2)
		spectateHUD:TweenPosition(UDim2.new(0.15, 0, 1.1, 0), "Out", "Quart", 0.2)
		weaponDisplay:TweenPosition(UDim2.new(0.86, 0, 0.85, 0), "Out", "Quart", 0.2)
		weaponHUD:TweenPosition(UDim2.new(-0.5, 0, 0.3, 0), "Out", "Quart", 0.2)
		
		if shopHUD.Position == UDim2.new(0.3, 0, 0.25, 0) then
			shopHUD:TweenPosition(UDim2.new(-0.5, 0, 0.25, 0), "Out", "Quart", 0.2)
		else
			shopHUD:TweenPosition(UDim2.new(0.3, 0, 0.25, 0), "Out", "Quart", 0.2)
		end
	end)
	
	shopHUD.Cancel.CancelButton.MouseButton1Click:Connect(function()
		shopHUD:TweenPosition(UDim2.new(-0.5, 0, 0.25, 0), "Out", "Quart", 0.2)
	end)
--[!]--
	--//SettingsHUD
		local contentHolder = settingsHUD.ContentHolder
		--//Background Music
	contentHolder.BackgroundMusic.ContentFiller.Selector.MouseButton1Click:Connect(function()
		local darkColor = Color3.fromRGB(161, 137, 17)
		local lightColor = Color3.fromRGB(240, 205, 26)
		if contentHolder.BackgroundMusic.ContentFiller.Selector.Position == UDim2.new(0.72, 0, 0, 0) then
			soundService.BackgroundAudio.Volume = 0
			tweenService:Create(contentHolder.BackgroundMusic.ContentFiller.Selector, tweenInfo, {ImageColor3 = darkColor}):Play()
			contentHolder.BackgroundMusic.ContentFiller.Selector:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.1, false)
			wait(0.1)
			contentHolder.BackgroundMusic.ContentFiller.Selector:TweenSize(UDim2.new(0.28, 0, 1, 0), "Out", "Quart", 0.1, true)
		elseif contentHolder.BackgroundMusic.ContentFiller.Selector.Position == UDim2.new(0, 0, 0, 0) then
			soundService.BackgroundAudio.Volume = 0.75
			tweenService:Create(contentHolder.BackgroundMusic.ContentFiller.Selector, tweenInfo, {ImageColor3 = lightColor}):Play()
			contentHolder.BackgroundMusic.ContentFiller.Selector:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quart", 0.1, false)
			wait(0.1)
			contentHolder.BackgroundMusic.ContentFiller.Selector:TweenSizeAndPosition(UDim2.new(0.28, 0, 1, 0), UDim2.new(0.72, 0, 0, 0), "Out", "Quart", 0.1, true)
		end
	end)
	--//Click Sound
	contentHolder.EffectsAudio.ContentFiller.Selector.MouseButton1Click:Connect(function()
		local darkColor = Color3.fromRGB(28, 132, 52)
		local lightColor = Color3.fromRGB(55, 255, 102)
		if contentHolder.EffectsAudio.ContentFiller.Selector.Position == UDim2.new(0.72, 0, 0, 0) then
			soundService.InterfaceClick.Volume = 0
			tweenService:Create(contentHolder.EffectsAudio.ContentFiller.Selector, tweenInfo, {ImageColor3 = darkColor}):Play()
			contentHolder.EffectsAudio.ContentFiller.Selector:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.1, false)
			wait(0.1)
			contentHolder.EffectsAudio.ContentFiller.Selector:TweenSize(UDim2.new(0.28, 0, 1, 0), "Out", "Quart", 0.1, true)
		elseif contentHolder.EffectsAudio.ContentFiller.Selector.Position == UDim2.new(0, 0, 0, 0) then
			soundService.InterfaceClick.Volume = 0.5
			tweenService:Create(contentHolder.EffectsAudio.ContentFiller.Selector, tweenInfo, {ImageColor3 = lightColor}):Play()
			contentHolder.EffectsAudio.ContentFiller.Selector:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quart", 0.1, false)
			wait(0.1)
			contentHolder.EffectsAudio.ContentFiller.Selector:TweenSizeAndPosition(UDim2.new(0.28, 0, 1, 0), UDim2.new(0.72, 0, 0, 0), "Out", "Quart", 0.1, true)
		end
	end)
	--//Game Quality
	contentHolder.Quality.ContentFiller.Selector.MouseButton1Click:Connect(function()
		local darkColor = Color3.fromRGB(79, 25, 145)
		local lightColor = Color3.fromRGB(139, 44, 255)
		if contentHolder.Quality.ContentFiller.Selector.Position == UDim2.new(0.72, 0, 0, 0) then
--			UserSettings():GetService("UserGameSettings").SavedQualityLevel = 4
			tweenService:Create(contentHolder.Quality.ContentFiller.Selector, tweenInfo, {ImageColor3 = darkColor}):Play()
			contentHolder.Quality.ContentFiller.Selector:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.1, false)
			wait(0.1)
			contentHolder.Quality.ContentFiller.Selector:TweenSize(UDim2.new(0.28, 0, 1, 0), "Out", "Quart", 0.1, true)
		elseif contentHolder.Quality.ContentFiller.Selector.Position == UDim2.new(0, 0, 0, 0) then
--			UserSettings():GetService("UserGameSettings").SavedQualityLevel = 10
			tweenService:Create(contentHolder.Quality.ContentFiller.Selector, tweenInfo, {ImageColor3 = lightColor}):Play()
			contentHolder.Quality.ContentFiller.Selector:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quart", 0.1, false)
			wait(0.1)
			contentHolder.Quality.ContentFiller.Selector:TweenSizeAndPosition(UDim2.new(0.28, 0, 1, 0), UDim2.new(0.72, 0, 0, 0), "Out", "Quart", 0.1, true)
		end
	end)
	
	contentHolder.Themes.ContentFiller.Selector.MouseButton1Click:Connect(function()
		local darkColor = Color3.fromRGB(47, 66, 84)
		local lightColor = Color3.fromRGB(220, 220, 220)
		if contentHolder.Themes.ContentFiller.Selector.Position == UDim2.new(0.72, 0, 0, 0) then
			interfaceModule.changeTheme("dark")
			tweenService:Create(contentHolder.Themes.ContentFiller.Selector, tweenInfo, {ImageColor3 = darkColor}):Play()
			contentHolder.Themes.ContentFiller.Selector:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.1, false)
			wait(0.1)
			contentHolder.Themes.ContentFiller.Selector:TweenSize(UDim2.new(0.28, 0, 1, 0), "Out", "Quart", 0.1, true)
		elseif contentHolder.Themes.ContentFiller.Selector.Position == UDim2.new(0, 0, 0, 0) then
			interfaceModule.changeTheme("light")
			tweenService:Create(contentHolder.Themes.ContentFiller.Selector, tweenInfo, {ImageColor3 = lightColor}):Play()
			contentHolder.Themes.ContentFiller.Selector:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quart", 0.1, false)
			wait(0.1)
			contentHolder.Themes.ContentFiller.Selector:TweenSizeAndPosition(UDim2.new(0.28, 0, 1, 0), UDim2.new(0.72, 0, 0, 0), "Out", "Quart", 0.1, true)
		end
	end)
--[!]--
	--//Screen Alert
	function interfaceModule.screenAlert(player, type, text)
		local mainGui = player.PlayerGui.MainUI
			local alertText = mainGui.Alert.Description -- creates a yield that makes placing turrets clunky so I spawned in function
		spawn(function()
			if type == "transaction completed" then
				alertText.TextColor3 = Color3.fromRGB(0, 204, 81)
				alertText.Text = text
				alertText.Parent.Visible = true
				wait(1)
				alertText.Parent.Visible = false
			elseif type == "transaction failed" then
				alertText.TextColor3 = Color3.fromRGB(204, 23, 0)
				alertText.Text = text
				alertText.Parent.Visible = true
				wait(1)
				alertText.Parent.Visible = false
			end
		end)
	end
	
	--//PromptHUD
	promptHUD.ContentHolder.Cancel.MouseButton1Click:Connect(function()
		local turretPlaceDown = interfaceModule.Acquire["TurretPlaceDown"]
		promptHUD:TweenPosition(UDim2.new(0.35, 0, -0.8, 0), "Out", "Quart", 0.2, true)
		turretPlaceDown.removeHighlights()
		turretPlaceDown.confirmingPurchase = false
	end)
	
	--//Prompt Users
	function interfaceModule.promptUser(player, type, category, object)
		local itemModule = require(game:GetService("ReplicatedStorage").Assets.Modules.ItemModule)
		
		local function tweenIn()
			promptHUD:TweenPosition(UDim2.new(0.35, 0, 0.3, 0), "Out", "Quart", 0.2, true)
		end
		
		promptHUD.ContentHolder.Context.Text = object
		--//Confirmation Handler
		if type == "purchase" then
			promptHUD.ContentHolder.DiamondsHolder.Visible = true
			promptHUD.ContentHolder.CoinsHolder.Visible = true
			promptHUD.TitleHolder.Title.Text = "Purchase"
			tweenIn()
		elseif type == "upgrade" then
			promptHUD.TitleHolder.Title.Text = "Upgrade"
			promptHUD.ContentHolder.DiamondsHolder.Visible = true
			promptHUD.ContentHolder.CoinsHolder.Visible = true
			tweenIn()
		elseif type == "destroy" then
			promptHUD.TitleHolder.Title.Text = "Destroy"
			promptHUD.ContentHolder.DiamondsHolder.Visible = false
			promptHUD.ContentHolder.CoinsHolder.Visible = true
			tweenIn()
		elseif type == "removeUI" then
			promptHUD:TweenPosition(UDim2.new(0.35, 0, -0.8, 0), "Out", "Quart", 0.2, true)
		end
	end
	
--[!]--
	--//QuestsHUD
	displayChallengeProgress.OnClientEvent:Connect(function(type, challenge, amount)
		local reward = itemModule.Challenges[challenge]["Reward"]
		local goal = itemModule.Challenges[challenge]["Goal"]
		local description = itemModule.Challenges[challenge]["Description"]
		if type == "create" then
			local template = assets.Template.QuestTemplate:Clone()
			template.Name = challenge
			template.ProgressHolder.ProgressFiller.Size = UDim2.new(0,0,1,0)
			template.ProgressHolder.Goal.Text = "0/" .. goal
			template.RewardHolder.Info.Text = tostring(reward)
			template.ProgressHolder.Info.Text = description
			template.Parent = questHUD.ContentHolder.ScrollingFrame
		elseif type == "remove" then
			for i, v in pairs(questHUD.ContentHolder.ScrollingFrame:GetChildren()) do
				if v:IsA("Frame") and v.Name == challenge then
					if v.ProgressHolder.ProgressFiller.Size == UDim2.new(1, 0, 1, 0) then
						v:Destroy()
					end
				end
			end
		elseif type == "update" then
			for i, v in pairs(questHUD.ContentHolder.ScrollingFrame:GetChildren()) do
				if v:IsA("Frame") and v.Name == challenge then
					if amount < goal then
						v.ProgressHolder.Goal.Text = tostring(amount) .. "/" .. goal
						v.ProgressHolder.ProgressFiller:TweenSize(UDim2.new(amount/goal, 0, 1, 0), "Out", "Quart", 0.2, true)
					elseif amount >= goal then
						v.ProgressHolder.Goal.Text = tostring(goal) .. "/" .. goal
						if v.ProgressHolder.ProgressFiller.Size ~= UDim2.new(1,0,1,0) then
							v.ProgressHolder.ProgressFiller:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quart", 0.2, true)
						end
						v:Destroy()
					end
				end
			end
		end
	end)
--[!]--
	--//Open PlaceHUD
	placeHUD.MaximizeMovement.NavigationButton.MouseButton1Click:Connect(function()
		placeHUD.ActivatedHUD:TweenPosition(UDim2.new(0, 0, 0, 0), "Out", "Quart", 0.2, true)
	end)
	
	placeHUD.ActivatedHUD.MinimizeMovement.NavigationButton.MouseButton1Click:Connect(function()
		local turretPlaceDown = interfaceModule.Acquire["TurretPlaceDown"]
		placeHUD.ActivatedHUD:TweenPosition(UDim2.new(0, 0, 1.1, 0), "Out", "Quart", 0.2, true)
		turretPlaceDown.removeHighlights()
		turretPlaceDown.currentlyPlacingTurret = nil
	end)
	
	--//Place HUD Viewport
	for i, v in pairs(assets.Defenses:GetChildren()) do
		interfaceModule.placeHUDViewport(placeHUD.ActivatedHUD.PlaceHudShadow.PlaceHudHolder.Defenses[v.Name])
	end
--[!]--
	--//Prompt Money Handler
--//Currency Handler
	player.leaderstats.Coins.Changed:Connect(function()
		currencyHUD.CoinsShadow.CoinsHolder.CoinsText.Text = player.leaderstats.Coins.Value
		interfaceModule.requestTurretClientData()
	end)
	
	player.leaderstats.Diamonds.Changed:Connect(function()
		currencyHUD.DiamondsShadow.DiamondsHolder.DiamondsText.Text = player.leaderstats.Diamonds.Value
		interfaceModule.requestTurretClientData()
	end)
	
	promptHUD.ContentHolder.CoinsHolder.Button.MouseButton1Click:Connect(function()
		local turretPlaceDown = interfaceModule.Acquire["TurretPlaceDown"]
		local check
		
		if promptHUD.TitleHolder.Title.Text == "Purchase" and turretPlaceDown.currentHexToPlaceOn  then
			check = purchaseCheck:InvokeServer("purchaseTurret", "Coins", turretPlaceDown.currentlyPlacingTurret, turretPlaceDown.currentHexToPlaceOn)
			interfaceModule.promptUser(player, "removeUI", "Turrets", turretPlaceDown.currentlyPlacingTurret)
			if check then
				interfaceModule.screenAlert(player, "transaction completed", "Transaction Successful!")
				turretPlaceDown.removeHighlights()
				turretPlaceDown.confirmingPurchase = false
				interfaceModule.requestTurretClientData()
			else
				interfaceModule.screenAlert(player, "transaction failed", "Transaction Failed: Insufficient Coins!")
				turretPlaceDown.removeHighlights()
				turretPlaceDown.confirmingPurchase = false
				interfaceModule.requestTurretClientData()
					
			end
		end
		if promptHUD.TitleHolder.Title.Text == "Destroy" then
			print("MY DESTINY!")
			check = purchaseCheck:InvokeServer("destroyTurret", "Coins", turretPlaceDown.mainTurretFromPart)
			interfaceModule.promptUser(player, "removeUI", "Turrets", turretPlaceDown.mainTurretFromPart.Name)
			if check then
				interfaceModule.screenAlert(player, "transaction completed", "Successfully Destroyed: Defense Destroyed!!")
			end
			--removePlacement:FireServer(turret) -- hmm
		end
	end)
				
	promptHUD.ContentHolder.DiamondsHolder.Button.MouseButton1Click:Connect(function()
		local turretPlaceDown = interfaceModule.Acquire["TurretPlaceDown"]
		local check
		--local turret = promptHUD.Holder.Content.Filler.Viewport:FindFirstChildWhichIsA("Model").Name
		local value = interfaceModule.returnTurretCost(turretPlaceDown.currentlyPlacingTurret, "returnDiamonds")
		
		if promptHUD.TitleHolder.Title.Text == "Purchase" and turretPlaceDown.currentHexToPlaceOn then
			check = purchaseCheck:InvokeServer("purchaseTurret", "Diamonds", turretPlaceDown.currentlyPlacingTurret, turretPlaceDown.currentHexToPlaceOn)
			interfaceModule.promptUser(player, "removeUI", "Turrets", turretPlaceDown.currentlyPlacingTurret)
			if check then
				interfaceModule.screenAlert(player, "transaction completed", "Transaction Successful!")
				--confirmPlacement:FireServer(currentHex,turret)
				turretPlaceDown.removeHighlights()--(fakeHexPreview,currentlyPlacingTurret)
				turretPlaceDown.confirmingPurchase = false
				interfaceModule.requestTurretClientData()
			else
				interfaceModule.screenAlert(player, "transaction failed", "Transaction Failed: Insufficient Diamonds!")
				turretPlaceDown.removeHighlights()--(fakeHexPreview,currentlyPlacingTurret)
				turretPlaceDown.confirmingPurchase = false
				interfaceModule.requestTurretClientData()
			end
		end
	end)
	spawn(interfaceModule.resetInterface)
	
	--//Weapons Interface
		local connect
		
		player.Backpack.ChildAdded:Connect(function(child)			
			wait()
			if connect ~= nil then
				connect:Disconnect()
			end
			
			local runService = game:GetService("RunService")
			local viewport = weaponDisplay.WeaponsHolderShadow.WeaponsHolderFiller.WeaponHolder
			viewport:ClearAllChildren()
			if itemModule.Weapons[child.Name] ~= nil then -- Check to prevent player modifications
				
				local target = Instance.new("Model")
				target.Name = child.Name
				--[[
				for i, v in pairs(assets.Weapons:WaitForChild(child.Name):GetChildren()) do
					if v:IsA("BasePart") or v:IsA("MeshPart")  then
						print(v.Name)
						v:Clone()
						v.Parent = target
						if v.Name == "Handle" then
							target.PrimaryPart = v
						end
					end
				end
				--]]
				local cloneModel = child:Clone()
				cloneModel.Name = child.Name
				for i,v in pairs(cloneModel:GetDescendants()) do
					if not v:IsA("BasePart") then
						v:Destroy()
					end
				end
				
				cloneModel.Parent = target
				
				for i, v in pairs(cloneModel:GetChildren()) do
					v.Parent = target
					
					if v.Name == "Handle" then
						target.PrimaryPart = v
					end
				end
				
--				cloneModel:Destroy()
				target:SetPrimaryPartCFrame(CFrame.new(0, 0, 0))
				local centerObject = Instance.new("Part", target)
				centerObject.Anchored = true
				centerObject.Size = target:GetExtentsSize()
				centerObject.Transparency = 1
				centerObject.Position = Vector3.new(0, 0, 0)
				centerObject.Name = "CenterObject"
				target.PrimaryPart = centerObject
				
				target.Parent = viewport
				--equipWeapon:FireServer(player, "equip", child)
				local camera = Instance.new("Camera")
				viewport.CurrentCamera = camera
				print(target.Parent)
				
				camera.CFrame = CFrame.new(Vector3.new(target:SetPrimaryPartCFrame(CFrame.new(0, -2, 0))))
				camera.CFrame = CFrame.new(Vector3.new(0, 0, 5), target.PrimaryPart.Position)
				
				connect = runService.RenderStepped:Connect(function()
					if target.PrimaryPart then--target.Handlethen
						target:SetPrimaryPartCFrame(target.PrimaryPart.CFrame * CFrame.Angles(0, -math.rad(1), 0))
					end
				end)
			else
				--warn player
			end
		end)
		
		--//Workspace Viewport
			function interfaceModule.updateWorkspaceWeapon()
				local data = clientData:InvokeServer("returnData")
				local weapon = weaponsSurface.WeaponsDisplay:FindFirstChildWhichIsA("Tool").Name
					weaponsSurface.WeaponsDisplay:FindFirstChildWhichIsA("Tool"):Destroy()
				local item = itemModule.Weapons[weapon]
				local benchmark = data["Benchmark"]
				
				if benchmark ~= item then
					warn("Weapons benchmark does not match current weapon!")
				end
				
				local target
				target = itemModule.Weapons[benchmark + 1]
				
				assets.Weapons[target]:Clone().Parent = weaponsSurface.WeaponsDisplay
			end
		--Force weapon viewport
		function interfaceModule.ForceWeaponViewport(weapon)
			
		end
		
		--//Display on Interface
		for i, weapons in pairs(itemModule.Weapons) do
			local check
			if assets.Weapons:FindFirstChild(i) ~= nil then
				local slotTemplate = assets.Template.WeaponTemplate:Clone()
				slotTemplate.Name = i
				slotTemplate.Purchase.ClaimButton.Text = tostring(itemModule.Weapons[i]["Coins"].. " Coins")
				slotTemplate.WeaponName.Text = slotTemplate.Name
				slotTemplate.Parent = weaponHUD.ContentHolder.ScrollingFrame
				
				--//Purchase
					slotTemplate.Purchase.ClaimButton.MouseButton1Click:Connect(function()
					local playerData = clientData:InvokeServer("returnData")
					if slotTemplate.Purchase.ClaimButton.Text ~= "EQUIP" and slotTemplate.Purchase.ClaimButton.Text ~= "EQUIPPED" then
						if playerData["Owned Weapons"][slotTemplate.Name] == nil then
							if playerData["Coins"] > itemModule.Weapons[slotTemplate.Name]["Coins"] then
								check = purchaseCheck:InvokeServer("purchaseWeapon", "Coins", slotTemplate.Name)
								if check then
									interfaceModule.screenAlert(player, "transaction completed", slotTemplate.Name .. " Successfully Purchased!")
--									player.Character.Humanoid:UnequipTools()
--									player.Backpack:ClearAllChildren()
--									local clone = assets.Weapons[slotTemplate.Name]:Clone()
--									clone.Parent = player.Backpack
--									for x, y in pairs(playerData["Owned Weapons"]) do
--										slotTemplate.Parent[playerData["Owned Weapons"][x]].Purchase.ClaimButton.Text = "EQUIP"
--									end
								slotTemplate.Purchase.ClaimButton.Text = "EQUIP"
								else
									interfaceModule.screenAlert(player, "transaction failed", "Transaction Failed: Insufficient Coins!")
								end
							end
							
	--						player.Backpack:ClearAllChildren()
	--						local clone = assets.Weapons[slotTemplate.Name]:Clone()
	--						clone.Parent = player.Backpack
	--						for x, y in pairs(playerData["Owned Weapons"]) do
	--							slotTemplate.Parent[playerData["Owned Weapons"][x]].Purchase.ClaimButton.Text = "EQUIP"
	--						end
	--						slotTemplate.Purchase.ClaimButton.Text = "EQUIPPED"
						end
					elseif slotTemplate.Purchase.ClaimButton.Text == "EQUIPPED" then
						local viewport = weaponDisplay.WeaponsHolderShadow.WeaponsHolderFiller.WeaponHolder
						viewport:ClearAllChildren()
						equipWeapon:FireServer("unequip",slotTemplate.Name)
						local AnimationTracks = player.Character.Humanoid:GetPlayingAnimationTracks()
						for i,v in pairs(AnimationTracks) do
							if v.Name == "Hold" or v.Name == "Shoot" or v.Name == "Scope" then
								v:Stop() 
							end
						end
						wait()
						player.Backpack:ClearAllChildren()
						slotTemplate.Purchase.ClaimButton.Text = "EQUIP"
					elseif slotTemplate.Purchase.ClaimButton.Text == "EQUIP" then
						local own = false
						
						for i, v in pairs(playerData["Owned Weapons"]) do
							if v == slotTemplate.Name then
								own = true
								break
							end
						end
						
						if own then
							player.Backpack:ClearAllChildren()
							wait()
							equipWeapon:FireServer("equip", assets.Weapons[slotTemplate.Name])
							for i, v in pairs(playerData["Owned Weapons"]) do
								slotTemplate.Parent[v].Purchase.ClaimButton.Text = "EQUIP"
							end
							slotTemplate.Purchase.ClaimButton.Text = "EQUIPPED"
						else
							warn("Player does not own weapon")
							--warn ban
						end
					end
				end)
			end
		end
	--//Dev Products
		--//Coins
	currencyHUD.CoinsShadow.CoinsHolder.PurchaseCoins.PurchaseCoins.MouseButton1Click:Connect(function()
		currencyShopHUD.ContentHolder.Currency.Text = "COINS"
		local products = {590883916, 590884224, 590884626, 590885586, 590885825, 590887053}
		for i, v in pairs(currencyShopHUD.ContentHolder.ProductHolder:GetChildren()) do
			if v:IsA("Frame") then
				v:Destroy()
			end
		end
		
		for i, v in pairs(products) do
			local productInfo = marketplaceService:GetProductInfo(products[i], Enum.InfoType.Product)
			local templateClone = assets.Template.CurrencyTemplate:Clone()
			templateClone.Amount.Text = productInfo.Name
			templateClone.Cost.Text = productInfo.PriceInRobux .. " R$"
			templateClone.Name = tostring(products[i])
			templateClone.Parent = currencyShopHUD.ContentHolder.ProductHolder
			templateClone.Container.Image = "rbxassetid://3249949244"
			templateClone.Button.MouseButton1Click:Connect(function()
				--marketplaceService:PromptProductPurchase(player, products[i])
			end)
		end
		
		currencyShopHUD:TweenPosition(UDim2.new(0.3, 0, 0.25, 0), "Out", "Quart", 0.3, true)
	end)
	
	currencyHUD.DiamondsShadow.DiamondsHolder.PurchaseDiamonds.PurchaseDiamonds.MouseButton1Click:Connect(function()
		currencyShopHUD.ContentHolder.Currency.Text = "DIAMONDS"
		local products = {593425579, 593425398, 593426829, 593427458, 593426612, 593427203}
		for i, v in pairs(currencyShopHUD.ContentHolder.ProductHolder:GetChildren()) do
			if v:IsA("Frame") then
				v:Destroy()
			end
		end
		
		for i, v in pairs(products) do
			local productInfo = marketplaceService:GetProductInfo(products[i], Enum.InfoType.Product)
			local templateClone = assets.Template.CurrencyTemplate:Clone()
			templateClone.Amount.Text = productInfo.Name
			templateClone.Cost.Text = productInfo.PriceInRobux .. " R$"
			templateClone.Name = tostring(products[i])
			templateClone.Parent = currencyShopHUD.ContentHolder.ProductHolder
			templateClone.Container.Image = "rbxassetid://3249888407"
			templateClone.Button.MouseButton1Click:Connect(function()
				--marketplaceService:PromptProductPurchase(player, products[i])
			end)
		end
		
		currencyShopHUD:TweenPosition(UDim2.new(0.3, 0, 0.25, 0), "Out", "Quart", 0.2, true)
	end)
	
	currencyShopHUD.Cancel.CancelButton.MouseButton1Click:Connect(function()
		currencyShopHUD:TweenPosition(UDim2.new(-0.6, 0, 0.25, 0), "Out", "Quart", 0.2, true)
	end)
	
	afkTween = TweenInfo.new(2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	
	local function afkPulse()
		while wait() do
			tweenService:Create(afkAlert, afkTween, {TextTransparency = 1}):Play()
			wait(2)
			tweenService:Create(afkAlert, afkTween, {TextTransparency = 0}):Play()
			wait(2)
		end
	end
	
	spawn(afkPulse)
return interfaceModule