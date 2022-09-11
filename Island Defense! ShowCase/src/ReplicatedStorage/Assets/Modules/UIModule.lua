local player = game.Players.LocalPlayer
local uiModule = {Acquire = nil}

--//Prompt Users
	function uiModule.promptUser(player, type, category, object)
		local mainUI = player:WaitForChild("PlayerGui").MainUI
			local promptHUD = mainUI.PromptHUD
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

--//Loaders
	--//Functions
	function uiModule.screenAlert(player, type, text)
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
			
	--//Turret Data
	function uiModule.requestTurretClientData()
		local mainGui = player.PlayerGui:WaitForChild("MainUI")
			local placeHUD = mainGui.PlaceHUD
			local promptHUD = mainGui.PromptHUD
		local limitText = placeHUD.ActivatedHUD.PlaceHudShadow.LimitShadow.LimitFiller.PlaceAmount
		local clientData = game:GetService("ReplicatedStorage").Assets.Remotes.ClientData
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
	
	function uiModule.requestTurretCost(turret, amount)
		local mainGui = player.PlayerGui:WaitForChild("MainUI")
			local promptHUD = mainGui.PromptHUD
		local itemModule = require(game:GetService("ReplicatedStorage").Assets.Modules.ItemModule)
			
		if promptHUD.TitleHolder.Title.Text == "Purchase" then
			local coinCost = itemModule.Turrets[turret]["Coins"] + (amount * 80)
			local diamondCost = itemModule.Turrets[turret]["Diamonds"] + (amount * 25)
			promptHUD.ContentHolder.CoinsHolder.Amount.Text = tostring(coinCost)
			promptHUD.ContentHolder.DiamondsHolder.Amount.Text = tostring(diamondCost)
		elseif promptHUD.TitleHolder.Title.Text == "Destroy" then
			local coinCost = (itemModule.Turrets[turret]["Coins"]) * 0.45
			promptHUD.ContentHolder.CoinsHolder.Amount.Text = tostring(coinCost)
		end
	end
	
	--//Returns Turret Cost
	function uiModule.returnTurretCost(turret, type)
		local mainGui = player.PlayerGui:WaitForChild("MainUI")
			local promptHUD = mainGui.PromptHUD
		local itemModule = require(game:GetService("ReplicatedStorage").Assets.Modules.ItemModule)
			
		local clientData = game:GetService("ReplicatedStorage").Assets.Remotes.ClientData
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
			promptHUD.ContentHolder.CoinsHolder.Amount.Text = tostring(coinCost)
		end
		
		if type == "returnCoins" then
			return coinCost
		elseif type == "returnDiamonds" then
			return diamondCost
		end
	end
	
	--//Place HUD Viewport Handler
	function uiModule.placeHUDViewport(object)
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
	
	--//Weapons Viewport Handler
	function uiModule.updateWeaponViewport(object, viewport)
		viewport:ClearAllChildren()
		local runService = game:GetService("RunService")
		local target = game:GetService("ReplicatedStorage").Assets.Weapons[object.Name]:Clone()
		target.Parent = viewport
		local camera = Instance.new("Camera")
		viewport.CurrentCamera = camera
		viewport.ImageColor3 = Color3.new(0, 0, 0)
		
		camera.CFrame = CFrame.new(Vector3.new(target:SetPrimaryPartCFrame(CFrame.new(0, -2, 0))))
		camera.CFrame = CFrame.new(Vector3.new(0, 0, 10), target.PrimaryPart.Position)
		
		runService.Heartbeat:Connect(function()
			if target.PrimaryPart then
				target:SetPrimaryPartCFrame(target.PrimaryPart.CFrame * CFrame.Angles(0, -math.rad(1), 0))
			end
		end)
	end
		--//Workspace Viewport
		
		--//GuiViewport
		
return uiModule