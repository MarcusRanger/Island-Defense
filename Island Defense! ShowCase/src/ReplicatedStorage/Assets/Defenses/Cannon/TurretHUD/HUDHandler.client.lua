local runService = game:GetService("RunService")

runService.Heartbeat:Connect(function()
	local player = game.Players.LocalPlayer
		local character = player.Character
	local magnitude = (script.Parent.Parent.PrimaryPart.Position - character.HumanoidRootPart.Position).magnitude
	print(magnitude)
	if magnitude < 100 then
		script.Parent.Holder:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0,0,0,0), "Out", "Quart", 0.5, true)
	else
		script.Parent.Holder:TweenSizeAndPosition(UDim2.new(0.1, 0, 0.1, 0), UDim2.new(0.45, 0, 0.45, 0), "Out", "Quart", 0.5, true)
	end
end)