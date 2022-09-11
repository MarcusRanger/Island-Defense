local turretPlaceDown = {Acquire = nil}

local player = game.Players.LocalPlayer
--I gotta clean this up 
--//Services
local replicatedStorage = game.ReplicatedStorage
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

--//Holders
local assets = replicatedStorage.Assets
local previews = assets.DefensePreviews
local uiModule = require(assets.Modules.UIModule)
local itemModule = require(assets.Modules.ItemModule)

	--//Remotes
	local confirmPlacement = assets.Remotes:WaitForChild("ToConfirmDefense")
	local removePlacement = assets.Remotes:WaitForChild("ToRemoveDefense")
	local tileTick = assets.Remotes:WaitForChild("TilePlacementTick")
	local clientData = assets.Remotes:WaitForChild("ClientData")
	local dataEvent = assets.Remotes:WaitForChild("DataEvents")
	local purchaseCheck = assets.Remotes:WaitForChild("PurchaseCheck")
	
local Camera = workspace.CurrentCamera

local mainGui = player.PlayerGui:WaitForChild("MainUI")
local promptHUD = mainGui.PromptHUD
local placeHUD = mainGui.PlaceHUD
	local slotContainmentHolder = placeHUD.ActivatedHUD.PlaceHudShadow.PlaceHudHolder.Defenses

--//Empty
--mainTurretFromPart
turretPlaceDown.currentlyPlacingTurret = nil 
turretPlaceDown.currentHexToPlaceOn = nil
turretPlaceDown.currentPreview = nil
turretPlaceDown.fakeHexPreview = nil
turretPlaceDown.mainTurretFromPart = nil
turretPlaceDown.confirmingPurchase = false
--confirmingPurchase,


--CoinPurchaseConnect,DiamondPurchaseConnect
--Add cancel button

local function getMouseTarget()
	local cursorPosition = game:GetService("UserInputService"):GetMouseLocation()
	local oray = game.workspace.CurrentCamera:ViewportPointToRay(cursorPosition.x, cursorPosition.y, 0)
	local ray = Ray.new(game.Workspace.CurrentCamera.CFrame.p,(oray.Direction * 1000))
	return workspace:FindPartOnRay(ray)
end

local function getMouseTargetWithCoordinates(xAxis,yAxis)
	local oray = game.workspace.CurrentCamera:ViewportPointToRay(xAxis,yAxis, 0)
	local ray = Ray.new(game.Workspace.CurrentCamera.CFrame.p,(oray.Direction * 1000))
	return workspace:FindPartOnRay(ray)
end

local function findIT(From,Search) --Find object that is nested inside a object 
	for i,v in pairs(From:GetDescendants()) do 
		if v.Name == Search or v == Search then	
			return v
		end
	end	
	return nil
end


--local slotContainmentHolder = findIT(ScreenUi,"Defenses")

---------- COLORIZE TILE ----------

local function isColliding(model)
	local isColliding = false

	-- must have a touch interest for the :GetTouchingParts() method to work
	local touch = model.PrimaryPart.Touched:Connect(function() end)
	local touching = model.PrimaryPart:GetTouchingParts()
	
	-- if intersecting with something that isn't part of the model then can't place
	for i = 1, #touching do
		if (not touching[i]:IsDescendantOf(model)) then
			isColliding = true
			break
		end
	end

	-- cleanup and return
	touch:Disconnect()
	return isColliding
end

function turretPlaceDown.previewPlacementOfDefense(coordX,coordY)
	local partForTurretPlacement, mousepos = getMouseTargetWithCoordinates(coordX,coordY)
	--print("HI HEHE THIS IS MY MOUSE PLACEMENT "..mousepos)
	if turretPlaceDown.currentlyPlacingTurret then
		--print(partForTurretPlacement.Name,"black spider mann")
		if partForTurretPlacement and (partForTurretPlacement.Name == "Hexagon" and partForTurretPlacement:IsA("MeshPart")) then--and not player.Character:FindFirstChildOfClass("Tool") then
			if player:DistanceFromCharacter(partForTurretPlacement.Position) <= 30 and partForTurretPlacement:FindFirstChild("Selected") and not partForTurretPlacement.Selected.Value  then
			  	turretPlaceDown.removeHighlights()--(turretPlaceDown.fakeHexPreview,partForTurretPlacement)
				turretPlaceDown.highlightTileAndShowPreview(partForTurretPlacement,turretPlaceDown.currentlyPlacingTurret)
			end
		end
	elseif not turretPlaceDown.currentlyPlacingTurret and turretPlaceDown.fakeHexPreview then -- if player reclicks on ui element
		turretPlaceDown.removeHighlights()--(turretPlaceDown.fakeHexPreview,partForTurretPlacement)
	end	
end
	

function turretPlaceDown.highlightTileAndShowPreview(tile,gunToPreview)
	if turretPlaceDown.currentHexToPlaceOn ~= tile then -- we dont want to reset and delete preview on a tile we already have selected
		local newPreview = previews:FindFirstChild(gunToPreview)
		if newPreview then
			if turretPlaceDown.currentPreview then
		       turretPlaceDown. currentPreview:Destroy()
				turretPlaceDown.currentPreview = nil
			end
			
			local turretPreview = newPreview:Clone()
--		    turretPreview:SetPrimaryPartCFrame(tile.CFrame * CFrame.new(0, tile.Size.Y/2, 0) * turretPreview.Base.CFrame)
			turretPreview:SetPrimaryPartCFrame((tile.CFrame * CFrame.new(0, tile.Size.Y/2, 0)) * CFrame.new(0, turretPreview.Base.Size.Y, 0))
		--[[
		    for _, partToTrans in pairs(turretPreview.Model:GetChildren()) do
		        partToTrans.Transparency = 0.3
		    end
		--]]
			turretPreview.Parent = Camera
			local tilePreview = tile:Clone()
			tilePreview.Name = "fakeTile"
		    tilePreview:ClearAllChildren()
		    tilePreview.Transparency = 0.5
		    tilePreview.Material = Enum.Material.Neon  
			tilePreview.Parent = Camera
			
			if not isColliding(turretPreview) then
				tilePreview.BrickColor = BrickColor.new("Br. yellowish green")
				turretPlaceDown.currentHexToPlaceOn = tile
			
				--tileTick:FireServer(turretPlaceDown.currentHexToPlaceOn, true)
			else
				tilePreview.BrickColor = BrickColor.new("Really red")
			end
			turretPlaceDown.currentPreview = turretPreview
	    	turretPlaceDown.fakeHexPreview = tilePreview
		end
	end
end

---------- REMOVE COLORIZATION ----------

--I also renamed the slot to the name of the turret thats supposed to be there for testing

function turretPlaceDown.removeHighlights()--(highlightHex,hexToChangeValue)
	if turretPlaceDown.fakeHexPreview and turretPlaceDown.currentlyPlacingTurret then -- currentHexToPlaceOn, currentPreview, fakeHexPreview  	 --if highlightHex and hexToChangeValue then 
	   
		if turretPlaceDown.currentHexToPlaceOn then
	    	--tileTick:FireServer(turretPlaceDown.currentHexToPlaceOn, false)
		end
		if turretPlaceDown.currentPreview then
	       turretPlaceDown.currentPreview:Destroy()
			turretPlaceDown.currentPreview = nil
		end
		turretPlaceDown.fakeHexPreview:Destroy()	--highlightHex:Destroy()
	   	turretPlaceDown.fakeHexPreview = nil
		turretPlaceDown.currentHexToPlaceOn = nil
	end
end

function turretPlaceDown.setUpDefenseButtons()
	for i,itemButton in pairs(slotContainmentHolder:GetChildren()) do
		if itemButton:IsA("ImageButton") then
			itemButton.Place.MouseButton1Click:Connect(function()
				for x, y in pairs(slotContainmentHolder:GetChildren()) do
					if y:IsA("ImageButton") then
						y.ImageTransparency = 0.9
					end
				end
				
				if turretPlaceDown.currentlyPlacingTurret == itemButton.Name then
					itemButton.ImageTransparency = 0.9
					turretPlaceDown.removeHighlights()
					turretPlaceDown.currentlyPlacingTurret = nil
					return
				end
				itemButton.ImageTransparency = 0.8
				turretPlaceDown.currentlyPlacingTurret = itemButton.Name
			end)
		end
	end
end

function turretPlaceDown.placeOrRemoveDefense()
	local tutorialModule = turretPlaceDown.Acquire["TutorialModule"]
	local playerData = clientData:InvokeServer("returnData")
	local placedTurrets = playerData["Number of Placed Turrets"]
	local turretLimit = playerData["Turret Limit"]
		
	local partForTurretPlacement, mousepos = getMouseTarget()
	if turretPlaceDown.currentlyPlacingTurret and turretPlaceDown.currentHexToPlaceOn then -- ready to confirm turret placement
		if placedTurrets >= turretLimit then
			uiModule.screenAlert(player, "transaction failed", "Placement Failed: Turret Limit Exceeded. Purchase More!")
		else
			local numTurrets = playerData["Owned Turrets"][turretPlaceDown.currentlyPlacingTurret]
			local purchasedTurrets = playerData["Purchased Turrets"][turretPlaceDown.currentlyPlacingTurret]
		--	if numTurrets < 1 then
				mainGui.PromptHUD.TitleHolder.Title.Text = "Purchase"
				uiModule.requestTurretCost(turretPlaceDown.currentlyPlacingTurret, purchasedTurrets)
				uiModule.promptUser(player, "purchase", "Turrets", turretPlaceDown.currentlyPlacingTurret)
				turretPlaceDown.confirmingPurchase = true
				tutorialModule.PlaceTurretLisenter = false
			--elseif numTurrets > 0 then
			--print(currentHexToPlaceOn,currentlyPlacingTurret)
				--confirmPlacement:FireServer(currentHexToPlaceOn,currentlyPlacingTurret)
			--[[
			--]]
			--dataEvent:FireServer("incrementTable", "Owned Turrets", -1, currentlyPlacingTurret)
			--dataEvent:FireServer("incrementTable", "Placed Turrets", 1, currentlyPlacingTurret)
			--dataEvent:FireServer("increment", "Number of Placed Turrets", 1)	
	
		end
	end

	--print(partForTurretPlacement.Name,turretPlaceDown.currentlyPlacingTurret)
	if partForTurretPlacement and not turretPlaceDown.currentlyPlacingTurret and partForTurretPlacement:IsDescendantOf(workspace.Gameplay.Defenses) and not player.Character:FindFirstChildOfClass("Tool") then 
		local mainPart = partForTurretPlacement:FindFirstAncestorWhichIsA("Model")
		--print(mainPart.Name,"OVER")
		if mainPart.Parent.playertag.Value == player then
			turretPlaceDown.mainTurretFromPart = mainPart.Parent
			mainGui.PromptHUD.TitleHolder.Title.Text = "Destroy"
			uiModule.promptUser(player, "destroy", "Turrets", turretPlaceDown.mainTurretFromPart.Name) -- this is the object we need to destroy no .Name at the end 
			uiModule.requestTurretCost(turretPlaceDown.mainTurretFromPart.Name)
		end
	end
end


UserInputService.InputChanged:Connect(function(input, GameHandledEvent) -- placement preview
	if GameHandledEvent then
		return	
	end
	if input.UserInputType == Enum.UserInputType.MouseMovement and not turretPlaceDown.confirmingPurchase then
	   	turretPlaceDown.previewPlacementOfDefense(input.Position.X,input.Position.Y)
	elseif input.UserInputType == Enum.UserInputType.Touch and not turretPlaceDown.confirmingPurchase then
		turretPlaceDown.previewPlacementOfDefense(input.Position.X,input.Position.Y)
	end
end)

--For Mobile users to place down turret
UserInputService.TouchLongPress:Connect(function(TouchPositions, state, GameHandledEvent)
	if GameHandledEvent then
		return
	end
	if state == Enum.UserInputState.Begin then
		print("carried by six")
		turretPlaceDown.placeOrRemoveDefense()	
	end	
end)

--For PC users to place down turret

UserInputService.InputBegan:Connect(function(InputObject, GameHandledEvent) -- handles mouse1 and touch
	if GameHandledEvent then
		return
	end
	if InputObject.UserInputType == Enum.UserInputType.Keyboard then
		if InputObject.KeyCode == Enum.KeyCode.X and not turretPlaceDown.confirmingPurchase then 
			turretPlaceDown.removeHighlights()
			turretPlaceDown.currentlyPlacingTurret = nil
		end
	end
	if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then -- or InputObject.UserInputType == Enum.UserInputType.Touch then
      turretPlaceDown.placeOrRemoveDefense()
	end
	
	--if InputObject.UserInputType == Enum.

end)


return turretPlaceDown
