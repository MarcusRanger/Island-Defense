spawn(function()
	while true do
		wait(10)
		for i,v in next, script.Parent:GetDescendants() do
			if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" and v.Name ~= "HandleSword" then
				if v.Transparency ~= 1 then
					spawn(function()
						script.Parent.ParticlePart.CFrame = script.Parent.HumanoidRootPart.CFrame
						
						script.Parent.ParticlePart.Sparkles.Enabled = true
						wait(0.2)
						script.Parent.ParticlePart.Sparkles.Enabled = false
					end)
				end
				v.Transparency = 1
			end
		end
		--[[
		for i,v in next, script.Parent:GetDescendants() do
			if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
				for i = 1,1 do
					wait()
					v.Transparency = v.Transparency -0.5
				end
			end
		end
		--]]
	end
end)

spawn(function()
	while true do
		wait(20)
		for i,v in next, script.Parent:GetDescendants() do
			if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
				for i = 1,1 do
					wait()
					v.Transparency = v.Transparency -0.5
				end
			end
		end
	end
end)


