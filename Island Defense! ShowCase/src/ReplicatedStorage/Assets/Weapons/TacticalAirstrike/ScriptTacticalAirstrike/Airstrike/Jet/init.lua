--Created by StarWars
local Bomb = require(script.Bomb)

local Jet = {}
Jet.__index = Jet

local Fires = {}

local JET_HEIGHT = 200
local JET_DISTANCE = 2000
local JET_SPEED = 300
local JET_DROP_RANGE = 550

local CUSTOM_PRE_EXPLOSION_EFFECT = false
local CUSTOM_EXPLOSION_EFFECT = false
local FIRE_EFFECT = true

local GRAVITY = workspace.Gravity
local WAIT_TIME = 0

local function CreateJet(player, location)
	local Model = Instance.new("Model")
	Model.Name = "F22 Bombing Jet"
	local Part = Instance.new("Part")
	Part.Locked = true
	Part.Name = "Torso"
	Part.Transparency = 0
	Part.CanCollide = true
	Part.TopSurface = Enum.SurfaceType.Smooth
	Part.BottomSurface = Enum.SurfaceType.Smooth
	Part.Size = Vector3.new(20, 5, 20)
	Part.CFrame = CFrame.new(location + Vector3.new(0, JET_HEIGHT, 0)) * CFrame.Angles(0, math.pi*2*math.random(), 0) * CFrame.new(0, 0, JET_DISTANCE)
	Part.Parent = Model
	
	local Mesh = Instance.new("SpecialMesh")
	Mesh.MeshId = "rbxassetid://88775328"
	Mesh.TextureId = ""
	Mesh.Scale = Vector3.new(10, 10, 10)
	Mesh.Parent = Part
	
	        local a0 = Instance.new("Attachment")
	        local a1 = Instance.new("Attachment")
	        a0.Position = Vector3.new(15.675, -2.191, 9.605)
	        a0.Name = "A0"
	        a1.Position = Vector3.new(13.503, -2.191, 9.605)
	        a1.Name = "A1"
	        a0.Parent = Part
	        a1.Parent = Part
	
		    local a2 = Instance.new("Attachment")
	        local a3 = Instance.new("Attachment")
	        a2.Position = Vector3.new(-15.675, -2.191, 9.605)
	        a2.Name = "A2"
	        a3.Position = Vector3.new(-13.503, -2.191, 9.605)
	        a3.Name = "A3"
	        a2.Parent = Part
	        a3.Parent = Part
	
		    local a4 = Instance.new("Attachment")
	        local a5 = Instance.new("Attachment")
	        a4.Position = Vector3.new(-10.066, -2.191, 20.161)
	        a4.Name = "A4"
	        a5.Position = Vector3.new(-8.018, -2.191, 20.381)
	        a5.Name = "A5"
	        a4.Parent = Part
	        a5.Parent = Part
	
		    local a6 = Instance.new("Attachment")
	        local a7 = Instance.new("Attachment")
	        a6.Position = Vector3.new(10.066, -2.191, 20.161)
	        a6.Name = "A6"
	        a7.Position = Vector3.new(8.018, -2.191, 20.381)
	        a7.Name = "A7"
	        a6.Parent = Part
	        a7.Parent = Part
	
    	    local trail = Instance.new("Trail")
	        trail.Name = "TrailEffect"
	        trail.Attachment0 = a0
	        trail.Attachment1 = a1		
	        trail.Enabled = true
	        trail.Lifetime = 3
	        trail.MinLength = 0.1
	        trail.Transparency = NumberSequence.new(0.5,1)
	        trail.FaceCamera = false
	        trail.Parent = Part
	
	    	local trail2 = Instance.new("Trail")
	        trail2.Name = "TrailEffect2"
	        trail2.Attachment0 = a2
	        trail2.Attachment1 = a3		
	        trail2.Enabled = true
	        trail2.Lifetime = 3
	        trail2.MinLength = 0.1
	        trail2.Transparency = NumberSequence.new(0.5,1)
	        trail2.FaceCamera = false
	        trail2.Parent = Part
	
		    local trail3 = Instance.new("Trail")
	        trail3.Name = "TrailEffect3"
	        trail3.Attachment0 = a4
	        trail3.Attachment1 = a5		
	        trail3.Enabled = true
	        trail3.Lifetime = 3
	        trail3.MinLength = 0.1
	        trail3.Transparency = NumberSequence.new(0.5,1)
	        trail3.FaceCamera = false
	        trail3.Parent = Part
	
		    local trail4 = Instance.new("Trail")
	        trail4.Name = "TrailEffect4"
	        trail4.Attachment0 = a6
	        trail4.Attachment1 = a7		
	        trail4.Enabled = true
	        trail4.Lifetime = 3
	        trail4.MinLength = 0.1
	        trail4.Transparency = NumberSequence.new(0.5,1)
	        trail4.FaceCamera = false
	        trail4.Parent = Part
	
	local HeadPart = Instance.new("Part")
	HeadPart.Locked = true
	HeadPart.Name = "Head"
	HeadPart.Transparency = 1
	HeadPart.Size = Vector3.new(0, 0, 0)
	HeadPart.Parent = Model
	
	local BurnPart = Instance.new("Part")
	BurnPart.Locked = true
	BurnPart.Name = "Burnt"
	BurnPart.Transparency = 1
	BurnPart.Size = Vector3.new(10, 5, 20)
	BurnPart.Parent = Model
	
	local ExplodePart = Instance.new("Part")
	ExplodePart.Locked = true
	ExplodePart.Name = "Explode"
	ExplodePart.Transparency = 1
	ExplodePart.Size = Vector3.new(0, 0, 0)
	ExplodePart.Parent = Model
	
	local BodyForce = Instance.new("BodyForce")
	BodyForce.Force = Vector3.new(0, (Part:GetMass() + HeadPart:GetMass())*GRAVITY, 0)
	BodyForce.Parent = Part
	
	local Weld = Instance.new("Weld")
	Weld.Name = "Neck"
	Weld.Part0 = Part
	Weld.Part1 = HeadPart
	Weld.Parent = Part
	
	local WeldB = Instance.new("Weld")
	WeldB.Name = "BurnWeld"
	WeldB.Part0 = Part
	WeldB.Part1 = BurnPart
	WeldB.Parent = Part
	
	local WeldE = Instance.new("Weld")
	WeldE.Name = "ExplodeWeld"
	WeldE.Part0 = Part
	WeldE.Part1 = ExplodePart
	WeldE.Parent = Part
	
	local Humanoid = Instance.new("Humanoid")
	Humanoid.MaxHealth = 5
	Humanoid.Health = 5
	Humanoid.WalkSpeed = 0
	Humanoid.Sit = true
	Humanoid.Parent = Model
	
	local JetSound = Instance.new("Sound")
	JetSound.Name = "JetScream"
	JetSound.SoundId = "rbxassetid://88862455"
	JetSound.Volume = 0.6
	game:GetService("Debris"):AddItem(JetSound, 10)
	JetSound.Parent = workspace
	delay(2, function()
		JetSound:Play()
	end)
	
	local Velocity = ((location + Vector3.new(0, JET_HEIGHT, 0)) - Part.Position).Unit*JET_SPEED
	Part.Velocity = Velocity
	HeadPart.Velocity = Velocity	

	Model.Parent = workspace
	
	return Model
end

local function CreateExplosion(jet)
	local PreExplosion = Instance.new("Explosion")
	PreExplosion.Position = jet.Torso.Position
	PreExplosion.BlastPressure = 0
	PreExplosion.BlastRadius = 100
	PreExplosion.ExplosionType = Enum.ExplosionType.CratersAndDebris
	PreExplosion.Parent = workspace
	
	local PreSound = Instance.new("Sound")
	PreSound.SoundId = "http://www.roblox.com/asset?id=206049428"
	PreSound.Volume = 5
	PreSound.Parent = jet.Torso
	PreSound:Play()
	
	if CUSTOM_PRE_EXPLOSION_EFFECT then
	PreExplosion.Visible = false
	local C = script.PreExplosionEffect:GetChildren()
    for i=1,#C do
		if C[i].className == "ParticleEmitter" then
	        local count = 1
			local Particle = C[i]:Clone()
		    if Particle:FindFirstChild("EmitCount") then
			count = Particle.EmitCount.Value
		    end
			Particle.Parent = jet.Explode
			delay(0.01,function()
			Particle:Emit(count)
			game.Debris:AddItem(Particle,Particle.Lifetime.Max)
		    end)
		end
    end
    end	
	
	if FIRE_EFFECT then
	local C = script.FireEffect:GetChildren()
	for i=1,#C do
		if C[i].className == "ParticleEmitter" then
			local Particle = C[i]:Clone()
			table.insert(Fires,Particle)
			Particle.Parent = jet.Burnt
			delay(0.01,function()
			Particle.Enabled = true
		    end)
		end
	end
	end	
	
	if jet.Head then
		jet.Head:Destroy()
	end
	
	jet.Torso.Velocity = jet.Torso.Velocity + Vector3.new((math.random()-.5)*50,(math.random()-.5)*50,(math.random()-.5)*50)
	wait(3)
	if jet.Torso then
		jet.Torso.Transparency = 1
		jet.Torso.Velocity = jet.Torso.Velocity + Vector3.new((math.random()-.5)*50,(math.random()-.5)*50,(math.random()-.5)*50)
		
	    local Explosion = Instance.new("Explosion")
	    Explosion.Position = jet.Torso.Position
	    Explosion.BlastPressure = 0
	    Explosion.BlastRadius = 100
	    Explosion.ExplosionType = Enum.ExplosionType.CratersAndDebris
	    Explosion.Parent = workspace
	
	    local Sound = Instance.new("Sound")
	    Sound.SoundId = "http://www.roblox.com/asset/?id=170278900"
	    Sound.Volume = 5
	    Sound.Parent = jet.Torso
	
	    local Sound2 = Instance.new("Sound")
	    Sound2.SoundId = "http://www.roblox.com/asset/?id=55224766"
	    Sound2.Volume = 5
	    Sound2.Parent = jet.Torso
	
		Sound:Play()
	    Sound2:Play()
	
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
			    Particle.Parent = jet.Explode
			    delay(0.01,function()
			    Particle:Emit(count)
			    game.Debris:AddItem(Particle,Particle.Lifetime.Max)
		        end)
		    end
	    end	
	    end
		
	    for _, Trails in pairs(jet.Torso:GetChildren()) do
	     	if Trails.className == "Trail" then
                Trails.Enabled = false	
		    end
	    end		
		
	    for _, Fire in pairs(Fires) do
		    Fire.Enabled = false
	    end		
		
	end
	wait(3)
end

function Jet.new(player, location)
	local self = {}
	setmetatable(self, Jet)
	
	self.Model = CreateJet(player, location)	
	delay(20, function()
		self.Alive = false
		self.Model:Destroy()
	end)
	self.Creator = player
	self.TargetLocation = location
	self.Alive = true
	self.Bombs = 3
	
	self.Model.Humanoid.HealthChanged:connect(function(health)
		if self.Alive then
			if self.Model.Humanoid then
				if self.Model.Humanoid.Health <= 0 then
					self.Alive = false
					if self.Model.Torso then
						self.Model.Humanoid:Destroy()
						CreateExplosion(self.Model)
					end
					self.Model:Destroy()
				end
			else
				self.Alive = false
				self.Model:Destroy()
			end
		end
	end)
	
	return self
end

function Jet:Fly()
	spawn(function()
		while self.Alive do
			if self.Model.Torso then
				if self.Bombs > 0 then
					if (self.Model.Torso.Position - self.TargetLocation).Magnitude < JET_DROP_RANGE then
						self.Bombs = self.Bombs - 1
						Bomb.new(self)
					end
				end
			end
			wait(.25)
		end
	end)
	while self.Alive do
		if self.Model.Torso then
			if self.Bombs > 0 then
				self.Model.Torso.Velocity = ((self.TargetLocation + Vector3.new(0, JET_HEIGHT, 0)) - self.Model.Torso.Position).Unit * self.Model.Torso.Velocity.Magnitude
			else
				self.Model.Torso.Velocity = self.Model.Torso.Velocity + Vector3.new(0, 10, 0)
			end
			self.Model.Torso.CFrame = CFrame.new(self.Model.Torso.Position, self.Model.Torso.Position + self.Model.Torso.Velocity)
		end
		wait(WAIT_TIME)
	end
end

return Jet