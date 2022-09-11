wait()

while wait() do
	local triggered = false
	local magnitude
	for i, v in pairs(game.Players:GetChildren()) do
		if v.Character ~= nil then
			magnitude = (script.Parent.Position - v.Character.HumanoidRootPart.Position).magnitude
			if magnitude <= 19 then
				triggered = true
			end			
		end
	end
	
	if triggered then
		script.Parent.FireBreath.Enabled = true
	else
		script.Parent.FireBreath.Enabled = false
       script.Parent.Parent.Head.Fire:Stop()
	end
end