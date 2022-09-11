--Created by StarWars
local Bomb = {}
Bomb.__index = Bomb

local BLAST_RADIUS = 30
local BLAST_PRESSURE = 2*6^6

local CUSTOM_EXPLOSION_EFFECT = false

local CreatorValue = Instance.new("ObjectValue")
CreatorValue.Name = "creator"

local function CreateBomb(jet)
	local BombPart = Instance.new("Part")
	BombPart.Name = "Effect"
	BombPart.Size = Vector3.new(3, 3, 10) * 0.5
	BombPart.CanCollide = false
	BombPart.CFrame = jet.Model.Torso.CFrame
	BombPart.Velocity = jet.Model.Torso.Velocity
	
	local Mesh = Instance.new("SpecialMesh")
	Mesh.MeshId = "rbxassetid://88782666"
	Mesh.TextureId = "rbxassetid://88782631"
	Mesh.Scale = Vector3.new(6, 6, 6)
	Mesh.Parent = BombPart
	
	local Sound = Instance.new("Sound")
	Sound.SoundId = "rbxasset://sounds/collide.wav"
	Sound.Volume = 1
	Sound.Pitch = 0.75
	Sound.Parent = BombPart
	
	game:GetService("Debris"):AddItem(BombPart, 10)
	BombPart.Parent = workspace	
	
	return BombPart
end

local function Explode(bomb)
	if not bomb.Exploded then
		bomb.Exploded = true
		bomb.Model.Anchored = true
		bomb.Model.Transparency = 1
		local Sound = bomb.Model:FindFirstChild("Sound")
		if Sound then
			Sound:Play()
		end
		
		local Explosion = Instance.new("Explosion")
		Explosion.Position = bomb.Model.Position
		Explosion.BlastPressure = BLAST_PRESSURE
		Explosion.BlastRadius = BLAST_RADIUS
		Explosion.ExplosionType = Enum.ExplosionType.CratersAndDebris
		Explosion.Hit:connect(function(hit)
			if bomb.Creator and (hit.Name == "Head" or hit.Name == "HumanoidRootPart") then
				local Humanoid = hit.Parent:FindFirstChild("Humanoid")
				if Humanoid then
					--[[
					for _, v in ipairs(Humanoid:GetChildren()) do
						if v.Name == "creator" then
							v:Destroy()
						end
					end
					
					local NewCreator = CreatorValue:Clone()
					NewCreator.Value = bomb.Creator
					NewCreator.Parent = Humanoid
					--]]
					local Tagged = Humanoid.Parent:FindFirstChild("Tagged")
					if Tagged then
						Tagged.Value = bomb.Creator
					end
				end
			end
		end)
		
		Explosion.Parent = workspace
		
	    local ExplodePart = Instance.new("Part")
	    ExplodePart.Name = "Explode"
	    ExplodePart.Transparency = 1
	    ExplodePart.Size = Vector3.new(0,0,0)
	    ExplodePart.Anchored = true
	    ExplodePart.CanCollide = false
	    ExplodePart.Locked = true
	    ExplodePart.CFrame = CFrame.new(Explosion.Position)
	    ExplodePart.Parent = workspace
	
	    if CUSTOM_EXPLOSION_EFFECT then
		Explosion.Visible = false
     	local C = script.ExplosionEffect:GetChildren()
        for i=1,#C do
	     	if C[i].className == "ParticleEmitter" then
	            local count = 1
		    	local Particle = C[i]:Clone()
		        if Particle:FindFirstChild("EmitCount") then
		    	count = Particle.EmitCount.Value
		        end
		    	Particle.Parent = ExplodePart
		    	delay(0.01,function()
			    Particle:Emit(count)
		    	game.Debris:AddItem(Particle,Particle.Lifetime.Max)
		        end)
		    end
        end	
        end		
		
		wait(0.5)
		if bomb.Model and bomb.Model.Parent ~= nil then
			bomb.Model:Destroy()
		end
	end
end

function Bomb.new(jet)
	local self = {}
	setmetatable(self, Bomb)
	
	self.Model = CreateBomb(jet)
	self.Creator = jet.Creator
	self.Exploded = false
	
	self.Model.Touched:connect(function(hit)
		if hit and hit.Parent then
			if hit.Name ~= "Effect" and hit.Parent.Name ~= "F22 Bombing Jet" then
				Explode(self)
			end
		end
	end)
	
	return self
end

return Bomb