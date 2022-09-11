--< Services
local PlayerService = game:GetService('Players')

--< Variables
local Tool = script.Parent
local Handle = Tool:WaitForChild("Handle")
local MouseEvent = Tool:WaitForChild("MouseEvent")
local FirePointObject = Handle:WaitForChild("GunFirePoint")
local FastCast = require(Tool:WaitForChild("FastCast"))
local FireSound = Handle:WaitForChild("Fire")
local ImpactParticle = Handle:WaitForChild("ImpactParticle")
local Debris = game:GetService("Debris")

--REMEMBER: THERE'S RESOURCES TO HELP YOU AT https://github.com/XanTheDragon/FastCastAPIDocs/wiki/API
local BULLET_SPEED = 800 --Studs/second - the speed of the bullet
local BULLET_MAXDIST = 100 --The furthest distance the bullet can travel 
local BULLET_DROP_GRAVITY = 0 --The amount of gravity applied to the bullet. Default place gravity is 196.2 (see workspace.Gravity)
local BULLET_WIND_OFFSET = Vector3.new(0, 0, 0) --The amount of force applied to the bullet in world space. Useful for wind effects.
local CanFire = true --Used for a cooldown.

-- client variables
local Player
local Character

local FakeModel

--Now we set the caster values.
local Caster = FastCast.new() --Create a new caster object.
Caster.Gravity = BULLET_DROP_GRAVITY --Set the values accordingly.
Caster.ExtraForce = BULLET_WIND_OFFSET

--Make a base cosmetic bullet object. This will be cloned every time we fire off a ray.
local CosmeticBullet = Instance.new("Part")
CosmeticBullet.Material = Enum.Material.Neon
CosmeticBullet.Color = Color3.fromRGB(218, 133, 65)
CosmeticBullet.CanCollide = false
CosmeticBullet.Anchored = true
CosmeticBullet.Size = Vector3.new(0.1, 0.1, 2.4)

-- Find who is the player
local function findPlayerVariables()
	local funcPlayer = PlayerService:GetPlayerFromCharacter(script.Parent.Parent)
	if funcPlayer then
		Player = funcPlayer
		Character = funcPlayer.Character
	end
end

local function CleanPart(Part)
	for _, value in pairs(Part:GetChildren()) do
		if value ~= nil then
			value:Destroy()
		end
	end
end

function tagHumanoid(humanoid, player)
	local Tagged = humanoid.Parent:FindFirstChild("Tagged")
	if Tagged then
		Tagged.Value = player
	end
	--[[
	local creator_tag = Instance.new("StringValue")
	creator_tag.Value = player.Name
	creator_tag.Name = "creator"
	creator_tag.Parent = humanoid
	--]]
end
function untagHumanoid(humanoid)
	if humanoid ~= nil then
		local tag = humanoid:FindFirstChild("creator")
		if tag ~= nil then
			tag:Destroy()
		end
	end
end

--And a function to play fire sounds.
function PlayFireSound()
	local NewSound = FireSound:Clone()
	NewSound.Parent = Handle
	NewSound:Play()
	Debris:AddItem(NewSound, NewSound.TimeLength)
end

--Create the spark effect for the bullet impact
function MakeParticleFX(Position, Normal)
	--This is a trick I do with attachments all the time.
	--Parent attachments to the Terrain - It counts as a part, and setting position/rotation/etc. of it will be in world space.
	local Attachment = Instance.new("Attachment")
	Attachment.CFrame = CFrame.new(Position, Position + Normal)
	Attachment.Parent = workspace.Terrain
	local Particle = ImpactParticle:Clone()
	Particle.Enabled = true
	Particle.Parent = Attachment
	Debris:AddItem(Attachment, Particle.Lifetime.Max)
	wait(0.05)
	Particle.Enabled = false
end

function Fire(Direction)
	local points = {script.Parent.Handle.GunFirePoint, script.Parent.Union2.GunFirePoint}
	
	for i = 1, #points do
		local point = points[i]
		--Called when we want to fire the gun.
		if Tool.Parent:IsA("Backpack") then return end --Can't fire if it's not equipped.
		--Note: Above isn't in the event as it will prevent the CanFire value from being set as needed.
		
		--Play the sound
		PlayFireSound()
		point.Muzzle.Enabled = true
		--Prepare a new cosmetic bullet
		local Bullet = CosmeticBullet:Clone()
		Bullet.CFrame = CFrame.new(point.WorldPosition, point.WorldPosition + Direction)
		Bullet.Parent = workspace
		Caster:Fire(point.WorldPosition, Direction * BULLET_MAXDIST, BULLET_SPEED, Bullet)
		wait(0.001)
		point.Muzzle.Enabled = false
	end
end

function OnRayHit(HitPart, HitPoint, Normal, Material, CosmeticBulletObject)
	--This function will be connected to the Caster's "RayHit" event.
	CosmeticBulletObject:Destroy() --Destroy the cosmetic bullet.
	if HitPart and HitPart.Parent then --Test if we hit something
		local Humanoid = HitPart.Parent:FindFirstChild("Humanoid") --Is there a humanoid?
		if Humanoid then
			local tagged = Humanoid.Parent:FindFirstChild("Tagged")
			if tagged then
				if HitPart.Name == "Handle" or HitPart.Name == "Head" then
					Humanoid.Health = Humanoid.Health-111 --Damage.
					tagHumanoid(Humanoid, Player)
					--wait(2)
					--untagHumanoid(Humanoid)
				else
					Humanoid.Health = Humanoid.Health-90
					tagHumanoid(Humanoid, Player)
					--wait(2)
					--untagHumanoid(Humanoid)
				end
				MakeParticleFX(HitPoint, Normal) --Particle FX
				script.Parent.Handle.Hit:Play()
			end
		end
	end
end

function OnRayUpdated(CastOrigin, SegmentOrigin, SegmentDirection, Length, CosmeticBulletObject)
	--Whenever the caster steps forward by one unit, this function is called.
	--The bullet argument is the same object passed into the fire function.
	local BulletLength = CosmeticBulletObject.Size.Z / 2 --This is used to move the bullet to the right spot based on a CFrame offset
	CosmeticBulletObject.CFrame = CFrame.new(SegmentOrigin, SegmentOrigin + SegmentDirection) * CFrame.new(0, 0, -(Length - BulletLength))
end

Tool.Equipped:Connect(function()
	findPlayerVariables()
	if FakeModel ~= nil then
		FakeModel:Destroy()
	end
	--This is going to be here so that we can prevent the caster from shooting the player or the gun.
	Caster.IgnoreDescendantsInstance = Tool.Parent
	script.Parent.Union2.Weld.Part1 = Tool.Parent.LeftHand
	script.Parent.Union2.Weld.C0 = CFrame.fromOrientation(math.rad(90), math.rad(-90), math.rad(0)) * CFrame.new(0, .5, .2)
end)
--[[
Tool.Unequipped:Connect(function()
	if Player and Character then
		local Torso = Character:FindFirstChild('Torso') or Character:FindFirstChild('UpperTorso')
		local FindTool = Character:FindFirstChild(script.Parent.Name)
		if Torso and FindTool == nil then
			FakeModel = Instance.new('Model', Character)
			FakeModel.Name = 'Pistol'
			
			-- Make first part
			local FakeHandle1 = script.Parent.Union:Clone()
			FakeHandle1.CanCollide = false
			FakeHandle1.Name = 'Handle1'
			CleanPart(FakeHandle1)
			
			local fromEulerAnglesXYZ = CFrame.fromEulerAnglesXYZ(10.5, math.rad(270), math.rad(180))
			
			local Weld1 = Instance.new('Weld')
			Weld1.Name = 'BackWeld'
			Weld1.Part0 = Torso
			Weld1.Part1 = FakeHandle1
			Weld1.C0 = CFrame.new(-1.1, -1.43, -0.3)
			Weld1.C0 = Weld1.C0 * fromEulerAnglesXYZ
			Weld1.Parent = FakeHandle1
			
			-- Make seconnd part
			local FakeHandle2 = script.Parent.Union2:Clone()
			FakeHandle2.CanCollide = false
			FakeHandle2.Name = 'Handle2'
			CleanPart(FakeHandle2)
			
			local Weld2 = Instance.new('Weld')
			Weld2.Name = 'BackWeld'
			Weld2.Part0 = Torso
			Weld2.Part1 = FakeHandle2
			Weld2.C0 = CFrame.new(1.15, -1.43, -0.3)
			Weld2.C0 = Weld2.C0 * fromEulerAnglesXYZ
			Weld2.Parent = FakeHandle2
			
			
			FakeHandle1.Parent = FakeModel
			FakeHandle2.Parent = FakeModel
		end
	end
end)
--]]
MouseEvent.OnServerEvent:Connect(function (ClientThatFired, MouseDirection)
	if not CanFire then
		return
	end
	CanFire = false
	script.Parent.Handle.GunFirePoint.Smoke.Enabled = true
	Fire(MouseDirection)
	wait(0.5)
	script.Parent.Handle.GunFirePoint.Smoke.Enabled = false
	CanFire = true
end)

Caster.LengthChanged:Connect(OnRayUpdated)
Caster.RayHit:Connect(OnRayHit)