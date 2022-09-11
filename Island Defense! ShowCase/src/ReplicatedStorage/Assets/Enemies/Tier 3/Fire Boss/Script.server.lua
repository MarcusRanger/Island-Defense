local Debris = game:GetService("Debris")
script.Parent.Humanoid.Died:Connect(function()
	local Boss = game:GetService("ServerStorage"):WaitForChild("Boss"):Clone()
	Boss.Position = script.Parent.UpperTorso.Position + Vector3.new(1, 0, 0)
	Boss.Parent = workspace
	game.Debris:AddItem(Boss, 17)
	local TweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(1.5)	
end)
