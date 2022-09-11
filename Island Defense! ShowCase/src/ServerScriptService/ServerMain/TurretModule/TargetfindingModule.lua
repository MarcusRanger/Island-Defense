
--[[
	@author: marcusc123
--]]
--local pathfindingService = game:GetService("PathfindingService")
local collectionService = game:GetService("CollectionService")
local debris = game:GetService("Debris")

local tweenService = game:GetService("TweenService")
local info = TweenInfo.new(.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out,  0,  false,  0)

local gameplayFolder = workspace.Gameplay
	local bulletSpace = gameplayFolder.Bullets
local effectsFolder = game.ReplicatedStorage.Assets.Effects

local targetModule = {Acquire = nil}

	local function tweenModel(model, CF)
	
		local CFrameValue = Instance.new("CFrameValue")
		CFrameValue.Value = model:GetPrimaryPartCFrame()
	
		CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
			if gameplayFolder.Defenses:IsAncestorOf(model) then
				model:SetPrimaryPartCFrame(CFrameValue.Value)
			end
		end)
		
		local tween = tweenService:Create(CFrameValue, info, {Value = CF})
		tween:Play()
		
		tween.Completed:Connect(function()
			CFrameValue:Destroy()
		end)
	end
	--workspace.Gameplay.Bullets
	local function shoot(defense,muzzle,endPos)
		if defense ~= nil then
			local ignore = {workspace.Gameplay.Defenses, workspace.Gameplay.Bullets} -- get a player list to add to ignore 
			local startPos = muzzle.Position
			local turretPrimaryPart = defense:FindFirstChild("Turret")
			if turretPrimaryPart then
				turretPrimaryPart = turretPrimaryPart.PrimaryPart
			end
			local range = 87-- change to whatever range the turret has. this is for visual effect
			local ray = Ray.new(startPos, (endPos - startPos).Unit * range)
			
			local magnitude = (endPos - startPos).magnitude
			local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, ignore)
			if hit then
				local hitHumanoid = hit:FindFirstChild("Humanoid") or hit.Parent:FindFirstChild("Humanoid")
				
				if hitHumanoid and hitHumanoid:IsDescendantOf(workspace.Gameplay.Enemies) and turretPrimaryPart then -- I want to prevent overflow errors
					muzzle.GunshotSound:Play()
					muzzle.GunshotParticle:Emit(4)
					--defense.Turret:SetPrimaryPartCFrame(CFrame.new(turretPrimaryPart.Position,endPos))
					local shot = effectsFolder.Bullet:Clone() 
					shot.CFrame = muzzle.CFrame
					shot.Parent = bulletSpace
					spawn(function()
						for i = 0, range/2 do
							shot.Attachment0.Position = shot.Attachment0.Position + Vector3.new(0, 0, -2) -- yoink
						end
						debris:AddItem(shot,1)
					end)
					tweenModel(defense.Turret,CFrame.new(turretPrimaryPart.Position,endPos))
					hitHumanoid:TakeDamage(7)
					if hitHumanoid.Parent then
						local tagged = hitHumanoid.Parent:FindFirstChild("Tagged")
						if tagged then
							--print("to me")
							tagged.Value = defense.playertag.Value
						end
						return true
					end
				end
			else
				return false -- oh no not in sight!
			end
		end
	end
	
	local function shootRocket(defense,muzzle, endPos)
		local ignore = {workspace.Gameplay.Defenses, workspace.Gameplay.Bullets}
		local turretPrimaryPart = defense.Turret.PrimaryPart
		local rocket = effectsFolder.Rocket:Clone()
		local startPos = muzzle.Position
		local range = (startPos - endPos).magnitude

		local ray = Ray.new(startPos, (endPos - startPos).Unit * range)
		local magnitude = (endPos - startPos).magnitude
		local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, ignore)
		if hit then
			local hitHumanoid = hit:FindFirstChild("Humanoid") or hit.Parent:FindFirstChild("Humanoid")
			
			if hitHumanoid and hitHumanoid:IsDescendantOf(workspace.Gameplay.Enemies) then
				local humanoidRootPart = hitHumanoid.Parent.HumanoidRootPart
				tweenModel(defense.Turret,CFrame.new(turretPrimaryPart.Position,endPos))
				rocket.Parent = bulletSpace
				rocket.CFrame = CFrame.new(muzzle.Position, humanoidRootPart.Position)*CFrame.Angles(math.rad(90),0,0)
				local blast = rocket.RocketPropulsion
				blast.ThrustP = 100
				blast.Target = hit
				blast.TurnP = 10
				blast.TargetRadius = 10
				blast.MaxSpeed = 30
				blast.CartoonFactor = 1
				blast:Fire()
				rocket.Sound:Play()
				blast.ReachedTarget:Connect(function()
					rocket.Explosion:Emit(20)
					rocket.ExplosionSound:Play()
					local explosion = Instance.new("Explosion")
					explosion.BlastPressure = 0 -- this could be set higher to still apply velocity to parts
					explosion.DestroyJointRadiusPercent = 0 -- joints are safe
					explosion.BlastRadius = 20
					explosion.Position = rocket.Position
					local modelsHit = {}
					explosion.Hit:Connect(function(part, distance)
						local parentModel = part.Parent
						if parentModel then 
							-- check to see if this model has already been hit 
							if modelsHit[parentModel] then
								return
							end
							-- log this model as hit
							modelsHit[parentModel] = true
				
							local humanoid = parentModel:FindFirstChild("Humanoid")
							if humanoid and humanoid:IsDescendantOf(workspace.Gameplay.Enemies) then
								humanoid:TakeDamage(40)
								local tagged = parentModel:FindFirstChild("Tagged")
								if tagged then
									tagged.Value = defense.playertag.Value
								end
							end
							rocket:Destroy()
						
						end
					end)
					explosion.Parent = workspace.Gameplay.Bullets
					if rocket then
						debris:AddItem(rocket,10) -- sometimes they dont destroy 
					end
				end)
				return true
			end
		else
			return false 
		end
	end

	local function getNewDefenseTarget(defense, range) -- yoinked from OG with modifications 
		local target
		local closestDist
		closestDist = range
		local turret = defense.Turret.PrimaryPart
		for i, v in pairs(collectionService:GetTagged("Enemy")) do
			if v:FindFirstChild("HumanoidRootPart") then
				local dist = (v.HumanoidRootPart.Position - turret.Position).magnitude
				if dist < closestDist then
					target = v
					closestDist = dist
				end
			end
		end
		if target then
			return target
		else
			return false
		end
	end

	function targetModule.getClosest(turret) -- enemy can be the turrets as well
		if turret:IsDescendantOf(workspace.Gameplay.Defenses) then 
			local closestDist = 80 -- change to turret range stat
			local currentTarget = getNewDefenseTarget(turret, closestDist)
			if currentTarget then
				targetModule.shootTarget(turret, currentTarget) -- "enemy" is the turret
			end
		end
	end
	
	function targetModule.shootTarget(defense, target)
		if target and defense then
			local turretPrimaryPart = defense.Turret.PrimaryPart
			local turretMuzzle = defense.Turret.UnionMuzzle
			--local
			local magnitude = (target.HumanoidRootPart.Position - turretPrimaryPart.Position).magnitude
			-- check if turret
			local num = 1
			repeat
					 --turretPrimaryPart.Position, target.HumanoidRootPart.Position
				local InSight
				if target:FindFirstChild("HumanoidRootPart") and defense then -- have to do second check or it bugs out...
					if defense.Name == "Cannon" then
						InSight = shoot(defense,turretMuzzle,target.HumanoidRootPart.Position) 
						wait(.28) -- point to turret stats this is firerate
						
					elseif defense.Name == "Machine Gun" then
						InSight = shoot(defense,turretMuzzle,target.HumanoidRootPart.Position) 
						wait(.15) -- point to turret stats this is firerate
					elseif defense.Name == "Rocket Launcher" then
						local burst = 2
						InSight = shootRocket(defense,turretMuzzle,target.HumanoidRootPart.Position)
						wait(1.5)
					end
				end
			until not defense or not target or magnitude > 87 or not InSight
		end
	end
	
return targetModule
