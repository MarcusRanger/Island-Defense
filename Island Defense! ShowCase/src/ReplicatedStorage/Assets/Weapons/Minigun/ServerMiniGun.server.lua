
local PlayerService = game:GetService('Players')

local Tool = script.Parent
local Handle = Tool:WaitForChild("Handle")
local MouseEvent = Tool:WaitForChild("MouseEvent")
local FirePointObject = Handle:WaitForChild("GunFirePoint")
local FastCast = require(Tool:WaitForChild("FastCast"))
local FireSound = Handle:WaitForChild("Fire")
local ImpactParticle = Handle:WaitForChild("ImpactParticle")
local Debris = game:GetService("Debris")

--REMEMBER: THERE'S RESOURCES TO HELP YOU AT https://github.com/XanTheDragon/FastCastAPIDocs/wiki/API
local BULLET_SPEED = 985 --Studs/second - the speed of the bullet
local BULLET_MAXDIST = 1000 --The furthest distance the bullet can travel 
local BULLET_DROP_GRAVITY = 0 --The amount of gravity applied to the bullet. Default place gravity is 196.2 (see workspace.Gravity)
local BULLET_WIND_OFFSET = Vector3.new(0, 0, 0) --The amount of force applied to the bullet in world space. Useful for wind effects.
local CanFire = true --Used for a cooldown.

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
CosmeticBullet.Size = Vector3.new(0.1, 0.1, 2.4)

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
	script.Parent.Parent.Humanoid:LoadAnimation(script.Parent.Shoot):Play()
	--Play the sound
	PlayFireSound()
	script.Parent.Handle.GunFirePoint.Muzzle.Enabled = true
	--Prepare a new cosmetic bullet
	local Bullet = CosmeticBullet:Clone()
	Bullet.CFrame = CFrame.new(FirePointObject.WorldPosition, FirePointObject.WorldPosition + Direction)
	Bullet.Parent = workspace
	Caster:Fire(FirePointObject.WorldPosition, Direction * BULLET_MAXDIST, BULLET_SPEED, Bullet)
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
					Humanoid.Health = Humanoid.Health-120 --Damage.
					local funcPlayer = PlayerService:GetPlayerFromCharacter(script.Parent.Parent)
					tagHumanoid(Humanoid, funcPlayer)
					--wait(2)
					--untagHumanoid(Humanoid)
				else
					Humanoid.Health = Humanoid.Health-70
					local funcPlayer = PlayerService:GetPlayerFromCharacter(script.Parent.Parent)
					tagHumanoid(Humanoid, funcPlayer)
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
	--This is going to be here so that we can prevent the caster from shooting the player or the gun.
	Caster.IgnoreDescendantsInstance = Tool.Parent
end)

local tool = script.Parent

MouseEvent.OnServerEvent:Connect(function (ClientThatFired, MouseDirection)
	if not CanFire then
		return
	end
	CanFire = false
	tool.Handle.GunFirePoint.Smoke.Enabled = true
	Fire(MouseDirection)
	wait(tool.DELAY_PER_SHOT.Value - (1/30))
	tool.Handle.GunFirePoint.Smoke.Enabled = false
	CanFire = true
end)

Caster.LengthChanged:Connect(OnRayUpdated)
Caster.RayHit:Connect(OnRayHit)