
local Weld = Instance.new("Weld")
Weld.Part0 = script.Parent.Head
Weld.C0 =  script.Parent.Head.CFrame:inverse()
Weld.Part1 = script.Parent.ParticlePart
Weld.C1 = script.Parent.ParticlePart.CFrame:inverse()
Weld.Parent = script.Parent.ParticlePart
script.Parent.ParticlePart.Anchored = false

function getplr()
	local plrs = {}
	for i,v in pairs(game.Players:GetPlayers()) do
		if v:DistanceFromCharacter(script.Parent.HumanoidRootPart.Position) < 15 then
			table.insert(plrs, v)
		end
	end
	return plrs
end

--[[
script.Parent.ParticlePart.FireBreath.Changed:connect(function(prop)
	if prop == "Enabled" then
		if script.Parent.ParticlePart.FireBreath.Enabled then
			for i=0,5,1 do
				wait(1)
				local plr = getplr()
				for i,v in pairs(plr) do
					if game.Players:FindFirstChild(v.Name) then
						v.Character.Humanoid:TakeDamage(10)
					end
				end
			end
		end
	end
end)
--]]

script.Parent.ParticlePart.FireBreath.Changed:connect(function(prop)
	if prop == "Enabled" then
		script.Parent.Head.Fire:Play()
		while script.Parent.ParticlePart.FireBreath.Enabled == true do
			--for i=0,5,1 do
				wait(1)
				local plr = getplr()
				for i,v in pairs(plr) do
					if game.Players:FindFirstChild(v.Name) then
						v.Character.Humanoid:TakeDamage(22)
						local part = script.FireBreath:Clone()
						part.Parent = v.Character.UpperTorso
						part.Enabled = true
						local script2 = script.DamagePlayer:Clone()
						script2.Parent = v.Character
						script2.Disabled = false
						wait(5)
						part:Destroy()
						script2:Destroy()
					end
				end
			--end
		end
	end
end)