local Tool = script.Parent
local Handle = Tool:WaitForChild("Handle")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local DELAY_PER_SHOT = Tool.DELAY_PER_SHOT.Value
local SPREAD_AMOUNT = Tool.SPREAD_AMOUNT.Value

local MouseEvent = Tool:WaitForChild("MouseEvent")

local Mouse = nil
local ExpectingInput = false
local Camera = workspace.CurrentCamera
local FirePointObject = Handle:WaitForChild("GunFirePoint")

function GetMouseDirection(MousePosOnScreen)
	local X = MousePosOnScreen.X
	local Y = MousePosOnScreen.Y
	local RayMag1 = Camera:ScreenPointToRay(X, Y) --Hence the var name, the magnitude of this is 1.
	local NewRay = Ray.new(RayMag1.Origin, RayMag1.Direction * 5000)
	local Target, Position = workspace:FindPartOnRay(NewRay, Players.LocalPlayer.Character)
	--NOTE: This ray is from CAMERA to cursor. This is why I check for a position value - With that value, I can get the proper direction
	return (Position - FirePointObject.WorldPosition).Unit
end

function UpdateMouseIcon()
	if Mouse and not Tool.Parent:IsA("Backpack") then
		Mouse.Icon = "rbxasset://textures/GunCursor.png"
	end
end

function OnEquipped(PlayerMouse)
	animTrack = game.Players.LocalPlayer.Character.Humanoid:LoadAnimation(script.Parent.Hold) -- Load animation into Humanoid
	animTrack:Play()
	
	Mouse = PlayerMouse
	ExpectingInput = true
	UpdateMouseIcon()
end

function OnUnequipped()
	animTrack:Stop()
	ExpectingInput = false
	UpdateMouseIcon()
end

Tool.Equipped:Connect(OnEquipped)
Tool.Unequipped:Connect(OnUnequipped)

local RandomObject = Random.new(tick()%1 * 1e7)

UserInputService.InputBegan:Connect(function (InputObject, GameHandledEvent)
	if GameHandledEvent or not ExpectingInput then
		--The ExpectingInput value is used to prevent the gun from firing when it shouldn't on the clientside.
		--This will still be checked on the server.
		return
	end
	
	if InputObject.UserInputType == Enum.UserInputType.MouseButton1 then
		RunService.RenderStepped:Wait()
		while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and Mouse) do
			if script.Parent.Rev.Value >= 50 then
			local FireDirection = GetMouseDirection(Vector2.new(
				Mouse.X + RandomObject:NextNumber(-SPREAD_AMOUNT, SPREAD_AMOUNT), 
				Mouse.Y + RandomObject:NextNumber(-SPREAD_AMOUNT, SPREAD_AMOUNT)
			))
			MouseEvent:FireServer(FireDirection)
			wait(DELAY_PER_SHOT)
			else
			script.Parent.Rev.Value = script.Parent.Rev.Value+1
			end
			end
		else
			script.Parent.Rev.Value = 0
	end
end)