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
local BULLET_SPEED = 400 --Studs/second - the speed of the bullet
local BULLET_MAXDIST = 110 --The furthest distance the bullet can travel 
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
CosmeticBullet.Color = Color3.fromRGB(248, 217, 109)
CosmeticBullet.CanCollide = false
CosmeticBullet.Anchored = true
CosmeticBullet.Size = Vector3.new(0.2, 0.2, 2.4)

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
	--Called when we want to fire the gun.
	if Tool.Parent:IsA("Backpack") then return end --Can't fire if it's not equipped.
	--Note: Above isn't in the event as it will prevent the CanFire value from being set as needed.
	
	--Play the sound
	PlayFireSound()
	script.Parent.Handle.GunFirePoint.Muzzle.Enabled = true
	--Prepare a new cosmetic bullet
	local Bullet = CosmeticBullet:Clone()
	Bullet.CFrame = CFrame.new(FirePointObject.WorldPosition, FirePointObject.WorldPosition + Direction)
	Bullet.Parent = workspace
	Caster:Fire(FirePointObject.WorldPosition + Vector3.new(0,1,0), Direction * BULLET_MAXDIST, BULLET_SPEED, Bullet)
	wait(0.01)
	local Bullet2 = CosmeticBullet:Clone()
	Bullet2.CFrame = CFrame.new(FirePointObject.WorldPosition, FirePointObject.WorldPosition + Direction)
	Bullet2.Parent = workspace
	Caster:Fire(FirePointObject.WorldPosition + Vector3.new(3,0,0), Direction * BULLET_MAXDIST, BULLET_SPEED, Bullet2)
	wait(0.01)
	local Bullet3 = CosmeticBullet:Clone()
	Bullet3.CFrame = CFrame.new(FirePointObject.WorldPosition, FirePointObject.WorldPosition + Direction)
	Bullet3.Parent = workspace
	Caster:Fire(FirePointObject.WorldPosition + Vector3.new(0,0,2), Direction * BULLET_MAXDIST, BULLET_SPEED, Bullet3)
	wait(0.01)
	local Bullet4 = CosmeticBullet:Clone()
	Bullet4.CFrame = CFrame.new(FirePointObject.WorldPosition, FirePointObject.WorldPosition + Direction)
	Bullet4.Parent = workspace
	Caster:Fire(FirePointObject.WorldPosition, Direction * BULLET_MAXDIST, BULLET_SPEED, Bullet4)
	wait(0.001)
	script.Parent.Handle.GunFirePoint.Muzzle.Enabled = false
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
					Humanoid.Health = Humanoid.Health-200 --Damage.
					tagHumanoid(Humanoid, Player)
					--wait(2)
					--untagHumanoid(Humanoid)
				else
					Humanoid.Health = Humanoid.Health-100
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

Tool.Equipped:Connect(function ()
	findPlayerVariables()
	if FakeModel ~= nil then
		FakeModel:Destroy()
	end
	--This is going to be here so that we can prevent the caster from shooting the player or the gun.
	Caster.IgnoreDescendantsInstance = Tool.Parent
end)

Tool.Unequipped:Connect(function()
	if Player and Character then
		local Torso = Character:FindFirstChild('Torso') or Character:FindFirstChild('UpperTorso')
		local FindTool = Character:FindFirstChild(script.Parent.Name)
		if Character:FindFirstChild('Shotgun') then
			Character.Shotgun:Destroy()
		end
		if Torso and FindTool == nil then
			FakeModel = Instance.new('Model', Character)
			FakeModel.Name = 'Shotgun'
			
			local FakeHandle = script.Parent.Union:Clone()
			FakeHandle.CanCollide = true
			FakeHandle.Name = 'Handle'
			
			local Pump = script.Parent.Pump:Clone()
			Pump.CanCollide = true
			Pump.Name = 'Pump'
			
			CleanPart(Pump)
			
			local WeldConstraint = Instance.new('WeldConstraint', Pump)
			WeldConstraint.Part0 = FakeHandle
			WeldConstraint.Part1 = Pump
			
			local Weld = Instance.new('Weld', FakeHandle)
			Weld.Name = 'BackWeld'
			Weld.Part0 = Torso
			Weld.Part1 = FakeHandle
			Weld.C0 = CFrame.new(0, -0.2, 0.5)
			Weld.C0 = Weld.C0 * CFrame.fromEulerAnglesXYZ(0, math.rad(180), math.rad(-45))

			Pump.Parent = FakeModel
			FakeHandle.Parent = FakeModel
		end
	end
end)

MouseEvent.OnServerEvent:Connect(function (ClientThatFired, MouseDirection)
	if not CanFire then
		return
	end
	CanFire = false
	script.Parent.Handle.GunFirePoint.Smoke.Enabled = true
	Fire(MouseDirection)
	wait(0.5)
	script.Parent.Pump.Tweening.Disabled = false
	wait(0.7)
	script.Parent.Pump.Tweening.Disabled = true
	wait(0.2)
	script.Parent.Handle.GunFirePoint.Smoke.Enabled = false
	CanFire = true
end)

Caster.LengthChanged:Connect(OnRayUpdated)
Caster.RayHit:Connect(OnRayHit)