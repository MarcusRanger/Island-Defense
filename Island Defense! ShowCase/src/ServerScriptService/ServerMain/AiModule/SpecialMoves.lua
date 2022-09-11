local specialMoves = {Acquire = nil}
	local Debris = game:GetService("Debris")
	local tweenService = game:GetService("TweenService")
	local CollectionService = game:GetService("CollectionService")
	local info = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out,  0,  false,  0)
	local EnemyFolder = workspace.Gameplay.Enemies
	local replicatedStorage = game.ReplicatedStorage
		local assets = replicatedStorage.Assets
			local Effects = assets.Effects
		
	local function tweenObjectColor(Object,color)
		local tween = tweenService:Create(Object, info, {Color = color})
		tween:Play()
	end
	
	-- you can change this up all you want to make the moves look nicer
	function specialMoves.FreezeTarget(Npc) 
		while wait(7) do
	  		local iceShard = Effects.IceShard:Clone()
			local humanoidRootPart = Npc:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart then
			    iceShard.CFrame = CFrame.new(humanoidRootPart.Position)
				iceShard.Size = Vector3.new(2,2,2)
				iceShard.Anchored = false
			    iceShard.Parent = workspace.Gameplay.Bullets
			    
			    local BodyVelocity = Instance.new("BodyVelocity")
			    BodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
			    BodyVelocity.Velocity = humanoidRootPart.CFrame.lookVector*23--iceShard.CFrame.LookVector * 50
			    BodyVelocity.Parent = iceShard
			    
			   
				local debounce = true
				iceShard.Touched:Connect(function(hit)
					if debounce then
						debounce = false
						local humanoid = hit.Parent:FindFirstChild("Humanoid")
						if humanoid and not hit:IsDescendantOf(Npc) and not hit:IsDescendantOf(workspace.Gameplay.Enemies) then-- and not humanoid:IsDescendantOf(workspace.Gameplay.Enemies) then
							local rootPart = hit.Parent:FindFirstChild("HumanoidRootPart")
							if rootPart then
								--iceShard:Destroy()
								print("I WANT TO FREEZE YOU!")
								local iceRock = Effects.IceRock:Clone()
			                    iceRock.CFrame = rootPart.CFrame
			                    iceRock.Parent = workspace.Gameplay.Bullets
			                    iceRock.Sound:Play() -- you can change 'Sound' to whatever you name the sound
			                   	Debris:AddItem(iceRock, 1.3)
								humanoid:TakeDamage(20)
								spawn(function()
									humanoid.WalkSpeed = 0
									wait(1.3)
									humanoid.WalkSpeed = 16
									print("im gone now")
								end)
								iceShard:Destroy()
							end
						end
						wait(.7)
						debounce = true
					end
				end)
				Debris:AddItem(iceShard, 4)
			end
			if not EnemyFolder:IsAncestorOf(Npc) then
				break
			end
	   	end
	end
	
	
	function specialMoves.WitchClone(Npc)

		local NewRandom = Random.new()
		while wait(40) and EnemyFolder:IsAncestorOf(Npc) do -- s  i g  h
			for i = 1,2 do
				local mob = assets.Enemies["Tier 2"]["Invisible Soldier"]:Clone()
				mob:SetPrimaryPartCFrame(Npc.HumanoidRootPart.CFrame + Vector3.new(NewRandom:NextNumber(10,-10),0,NewRandom:NextNumber(10,-10)))
				mob.Parent = workspace.Gameplay.Enemies
				CollectionService:AddTag(mob,"Enemy")
				wait(1)
			end
			if not EnemyFolder:IsAncestorOf(Npc) then -- may have to search if its under the enemies folder
				break
			end
		end
	end
	
	function specialMoves.FireBall(Npc)
		while wait(7) and EnemyFolder:IsAncestorOf(Npc) do
			local FireBall = Effects.FireBall:Clone()
			FireBall.CFrame = CFrame.new(Npc.HumanoidRootPart.Position) + Vector3.new(0,3,0)
			FireBall.Size = Vector3.new(6,6,6)
			FireBall.Anchored = false
			FireBall.Parent = workspace.Gameplay.Bullets
			
			local BodyVelocity = Instance.new("BodyVelocity")
			BodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
			BodyVelocity.Velocity = Npc.HumanoidRootPart.CFrame.lookVector*50--FireBall.CFrame.LookVector * 50
			BodyVelocity.Parent = FireBall
			local debounce = true
			FireBall.Touched:Connect(function(hit)
				if debounce then
					debounce = false
					print(hit.ClassName)
					if (hit:IsA("BasePart") or hit:IsA("MeshPart") or hit:IsA("Part")) and (not hit:IsDescendantOf(Npc)) then
--						print(hit.Name,script.Parent)
						local impactPart = Effects.ImpactFire:Clone()
						impactPart.Parent = workspace.Gameplay.Bullets
						impactPart.CFrame = hit.CFrame
						impactPart.Sound:Play()
						local spam = true
						impactPart.Touched:Connect(function(hit)
							if spam then
								spam = false
								local humanoid = hit.Parent:FindFirstChild("Humanoid")
								if humanoid and not humanoid:IsDescendantOf(workspace.Gameplay.Enemies) then
									humanoid:TakeDamage(6)
								end
							end
							wait(.3)
							spam = true
						end)
						Debris:AddItem(impactPart, 2)
						FireBall:Destroy()
					end
				end
				wait(.4)
				debounce = true
			end)
			Debris:AddItem(FireBall, 4)
		end
	end
	
	function specialMoves.Bomber(Npc)
		while wait(8) and EnemyFolder:IsAncestorOf(Npc) do -- play around with bomb timer
			local Timer = 4
			local Bomb = Effects.Bomb:Clone()
			local ExplosionSound = Bomb.Sound
			local humanoidRootPart = Npc:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart then
				Bomb.CFrame = humanoidRootPart.CFrame
			end
			Bomb.Transparency = 0
			Bomb.Parent = workspace
			Bomb.Anchored = false
			Bomb.CanCollide = true
			local CountDown = Bomb.BillboardGui:WaitForChild("Countdown")
			CountDown.TextTransparency = 0
			
			repeat 
				wait(1)
				Timer = Timer - 1
				CountDown.Text = Timer
				Bomb.BrickColor = BrickColor.new("Neon orange") --255, 154, 76
				wait(1)
				Timer = Timer - 1
				CountDown.Text = Timer
				Bomb.BrickColor = BrickColor.new("Really black")
				
			until Timer <= 0 
			ExplosionSound:Play()
			local CircleShockWave = Bomb.CircleShockWave:Clone()
			CircleShockWave.Size = Vector3.new(15,15,15)
			CircleShockWave.CFrame = Bomb.CFrame + Vector3.new(0,2,0)
			CircleShockWave.Parent = workspace.Gameplay.Bullets
			local CircleShockWaveInformation = TweenInfo.new(1.3,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0)
			local CircleShockWaveProperties = {Size = Vector3.new(120,120,120)}
			CircleShockWave.Transparency = .4
			--local CircleShockWaveVisible = {Transparency = 1}
			
			local TweenCircleShockWave = tweenService:Create(CircleShockWave,CircleShockWaveInformation,CircleShockWaveProperties)
			--local TweenCircleShockWaveVisible = tweenService:Create(CircleShockWave,CircleShockWaveVisible,CircleShockWaveProperties)
			TweenCircleShockWave:Play()
			--TweenCircleShockWaveVisible:Play()
			local explosion = Instance.new("Explosion")
			explosion.BlastPressure = 0 -- this could be set higher to still apply velocity to parts
			explosion.DestroyJointRadiusPercent = 0 -- joints are safe
			explosion.BlastRadius = 12
			explosion.Position = Bomb.Position
			explosion.Parent = workspace.Gameplay.Bullets
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
					if humanoid and not humanoid:IsDescendantOf(workspace.Gameplay.Enemies) then -- maybe make this mob kill other mobs
						humanoid:TakeDamage(35)
					end
				end
			end)
			Debris:AddItem(Bomb,1)
			Debris:AddItem(CircleShockWave,1.2)			
			if not EnemyFolder:IsAncestorOf(Npc) then
				break
			end
		end
	end
	
	function specialMoves.TurnInvisible(Npc)
		while wait(10) and EnemyFolder:IsAncestorOf(Npc) do
			for i,v in next, Npc:GetDescendants() do
				if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" and v.Name ~= "HandleSword" then
					if v.Transparency ~= 1 then
						spawn(function()
							Npc.ParticlePart.CFrame = Npc.HumanoidRootPart.CFrame
							
							Npc.ParticlePart.Sparkles.Enabled = true
							wait(0.2)
							Npc.ParticlePart.Sparkles.Enabled = false
						end)
					end
					v.Transparency = 1
				end
			end
			for i,v in next, Npc:GetDescendants() do
				if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
					for i = 1,1 do
						wait()
						v.Transparency = v.Transparency -0.5
					end
				end
			end
		end
	end
	
	function specialMoves.FireRoar(Npc)
		local firePart = Npc.UpperTorso.FireBreath
		while not firePart.Enabled do
			for _,player in pairs(game.Players:GetPlayers()) do
				if player:DistanceFromCharacter(Npc.HumanoidRootPart.Position) <= 10 then
					firePart.Enabled = true
					Npc.Head.Fire:Play()
					local humanoid = player.Character:FindFirstChild("Humanoid")
					if humanoid and not humanoid:IsDescendantOf(workspace.Gameplay.Enemies) then
						humanoid:TakeDamage(12)
						local fireClone = firePart:Clone()
						fireClone.Parent = humanoid.Parent.HumanoidRootPart
						fireClone.EmissionDirection = Enum.NormalId.Top
						Debris:AddItem(fireClone,1.6)
					end
				end
			end
			wait(2)
			firePart.Enabled = false
			Npc.Head.Fire:Stop()
		end	
	end
return specialMoves
