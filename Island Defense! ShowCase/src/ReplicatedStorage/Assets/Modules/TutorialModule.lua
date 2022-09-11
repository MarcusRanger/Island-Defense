local Tutorial = {Acquire = nil}

Tutorial.PlaceTurretLisenter = false -- put Tutorial.PlaceTurretLisenter = true below line 207 in TurretPlaceDown Module

local player = game.Players.LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local assets = replicatedStorage:WaitForChild("Assets")
	local remotes = assets.Remotes
		local clientData = remotes.ClientData
		local completedTutorial = remotes.CompletedTutorial

local mainGui = player.PlayerGui:WaitForChild("MainUI")
		local leftnav = mainGui.LeftNAV.WeaponsShadow.Filler.Label
		local weaponGrabStep = mainGui.WeaponHUD.ContentHolder.ScrollingFrame.Colt.Purchase.ClaimButton
		local placeTurretStep = mainGui.PlaceHUD.MaximizeMovement.NavigationButton
		local placeCannonStep = mainGui.PlaceHUD.ActivatedHUD.PlaceHudShadow.PlaceHudHolder.Defenses["Cannon"].Place
		local placeMachineGunStep = mainGui.PlaceHUD.ActivatedHUD.PlaceHudShadow.PlaceHudHolder.Defenses["Machine Gun"].Place
		local placeRocketStep = mainGui.PlaceHUD.ActivatedHUD.PlaceHudShadow.PlaceHudHolder.Defenses["Rocket Launcher"].Place

		
local StepTable = {
	[1] = {
	["UiElement"] = leftnav,
	["Step Text"] = "Click here for weapons",
	["Condition"] = false,
	["Arrow Position"] = nil,
	},
	
	[2] = {
	["UiElement"] = weaponGrabStep,
	["Step Text"] = "Here you can buy weapons, buy a Colt",
	["Condition"] = false,
	["Arrow Position"] = nil,
	},
	
	[3] = {
	["UiElement"] = weaponGrabStep,
	["Step Text"] = "Now, click again to equip the Colt",
	["Condition"] = false,
	["Arrow Position"] = nil,
	},
	
	[4] = {
	["UiElement"] = placeTurretStep,
	["Step Text"] = "Now, click here to access Turrets",
	["Condition"] = false,
	["Arrow Position"] = nil,								
	},
	
	[5] = {
	["UiElement"] = {placeRocketStep ,placeMachineGunStep ,placeCannonStep},
	["Step Text"] = "Click on any turret",
	["Condition"] = false,
	["Arrow Position"] = nil,								
	},
	
	[6] = {
	["UiElement"] = nil,
	["ObjectListener"] = true,
	["Step Text"] = "Click on any open hexagon to place turret",
	["Condition"] = false,
	["Arrow Position"] = nil,								--add more table stuff if you like or modify whatever I dont really like how Im approaching this anyway
	}
	
}

Tutorial.Completed = function()
	print("CONGRATS! YOU ARE FINISHED HERES 200 COINS!")
	completedTutorial:FireServer() -- should check the "First Time" playerData value
end

Tutorial.NextStep = function(step)
	if step > #StepTable then Tutorial.Completed() return false end
	local UiElement = StepTable[step]["UiElement"]
	if UiElement then
		--print(typeof(UiElement))
		if typeof(UiElement) == 'table' then
			print(StepTable[step]["Step Text"])
			for _,button in pairs(UiElement) do
				button.MouseButton1Click:Connect(function()
					if not StepTable[step]["ConditionReached"] then
						StepTable[step]["ConditionReached"] = true
						print("NEXT STEP!")
						Tutorial.NextStep(step + 1)
					end
				end)
			end
		else
			print(StepTable[step]["Step Text"])
			UiElement.MouseButton1Click:Connect(function()
				if not StepTable[step]["Condition"] then
					StepTable[step]["Condition"] = true
					print("NEXT STEP!")
					Tutorial.NextStep(step + 1)
				end
			end)
		end
	elseif StepTable[step]["ObjectListener"] then
		print(StepTable[step]["Step Text"])
		repeat wait(.2) until Tutorial.PlaceTurretLisenter
		Tutorial.NextStep(step + 1)
	end
end
--//
--function Tutorial:Init()
--	local playerData = clientData:InvokeServer("returnData")
	--	local firstTime = playerData["First Time"]
	
	--if firstTime then
	--	print("Welcome to Island Defense!")
	--	Tutorial.NextStep(1)
	--end
--end
--\\

return Tutorial
