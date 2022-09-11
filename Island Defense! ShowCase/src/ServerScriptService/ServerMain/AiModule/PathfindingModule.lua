--[[
	@author: marcusc123
--]]
local pathfindingService = game:GetService("PathfindingService")
local collectionService = game:GetService("CollectionService")
local gameplayFolder = workspace.Gameplay
	local currentMap = gameplayFolder.Holders.currentMap -- placeholder for now
	local MapFolder = gameplayFolder.Map
	local coreHealth = gameplayFolder.Holders.coreHealth
	
local NextPointThreshold = 7
local JumpThreshold = .45

local pathModule = {Acquire = nil}


	local function AiAttack(enemy,target) 
		local attacking = enemy:FindFirstChild("Attacking")
		if attacking and not attacking.Value then
			attacking.Value = true
			local ignore = {workspace.Gameplay.Enemies, workspace.Gameplay.Bullets}
			local attackRange = 10 --change to ai attack range stat
			local currentTarget = enemy:FindFirstChild("Target") -- 
			if currentTarget then
				local startPos = enemy.HumanoidRootPart.Position
				local endPos = target.Position
				local ray = Ray.new(startPos, (endPos - startPos).Unit * attackRange)
				local magnitude = (endPos - startPos).magnitude
				local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, ignore)
				--print(hit.Name)
				if hit then
				--	print("RARI AND SHIT")
					local hitHumanoid = hit:FindFirstChild("Humanoid") or hit.Parent:FindFirstChild("Humanoid") 
					local hitCore =  hit.Parent -- oof
					local hitTurret = hit.Parent.Parent -- oof
					if hitHumanoid then
						hitHumanoid:TakeDamage(6) -- change to AI attack function 
					elseif hitTurret:FindFirstChild("Health")  then
						hitTurret.Health.Value = hitTurret.Health.Value - 8 --change to ai attack stat
					elseif hitCore.Parent == "Core" or hitCore.Name == "Core" then
						coreHealth.Value = coreHealth.Value - 3 --change to ai attack stat
					end
				end
			end
		end
		wait(3) -- change to ai attack speed stat
		local attacking = enemy:FindFirstChild("Attacking") -- to stop pathfinding overflow errors
		if attacking then
			attacking.Value = false
		end
	end
	
	local function getNewAiTarget(enemy) -- yoinked from OG with modifications 
		local currentTarget
		local closestDist
		local attackDistance
		local targetPosition
		local currentCore = MapFolder[currentMap.Value].Core
		closestDist = 40 -- change to the AI view stat
		for _, v in pairs(collectionService:GetTagged("Target")) do
			if v:FindFirstChild("Turret") then
				targetPosition = v.Turret.PrimaryPart.Position
			elseif v:FindFirstChild("HumanoidRootPart") then
				targetPosition = v.HumanoidRootPart.Position
			else
				targetPosition = v.Position
			end
			local dist = (enemy.HumanoidRootPart.Position - targetPosition).magnitude
			if dist < closestDist then
				currentTarget = v
				closestDist = dist
			end
		end
		if currentTarget then
			enemy.Target.Value = currentTarget.Name
			return currentTarget
		elseif enemy.Target.Value ~= currentCore.Name then
--			print(currentCore.Name.. " is my friend")
			enemy.Target.Value = currentCore.Name
			return currentCore
		end
	end
	
	function pathModule.teleportReset(Mob)
		local Stuck = Mob:FindFirstChild("Stuck")
		if Stuck then
			if Stuck.Value >= 7 then
				Mob.HumanoidRootPart.Position = Mob.HumanoidRootPart.Position + Vector3.new(1,10,0)
				Stuck.Value = 0
			end
		end
	end

	function pathModule.getClosest(Mob)
		if Mob:IsDescendantOf(workspace.Gameplay.Enemies) then
			local currentTarget = getNewAiTarget(Mob)
			if currentTarget then
				spawn(function() 
					--pathModule.teleportReset(Mob)
					pathModule.moveToObject(Mob, currentTarget)
				end)
			end
		end
	end
	
	function pathModule.getSpecialMove(Mob) -- still have Ice mage to do
		local specialMoves = pathModule.Acquire["SpecialMoves"]
		if Mob.Name == "Red Witch" then
			specialMoves.WitchClone(Mob)
		elseif Mob.Name == "Kamikaze" then 
			specialMoves.Bomber(Mob)
		elseif Mob.Name == "Invisible Soldier" then 
			specialMoves.TurnInvisible(Mob)
		elseif Mob.Name == "Fire Boss" then
			spawn(function() specialMoves.FireRoar(Mob) end)
			specialMoves.FireBall(Mob)
		elseif Mob.Name == "Ice Mage" then
			specialMoves.FreezeTarget(Mob)
		end
	end

	function pathModule.moveToObject(enemy, target)
		if enemy and target and enemy:FindFirstChild("Pathing") then -- if I dont FindFirstChild on the pathing stringvalue then the script will bitch at me when the AI dies...
			if not enemy.Pathing.Value then
				local targetPart
				local connections = {}
				local workspaceSearch
				local currentTarget = enemy.Target
				local humanoid = enemy.Humanoid
				
				if target:FindFirstChild("Turret") then
					 targetPart = target.Turret.PrimaryPart
					workspaceSearch = workspace.Gameplay.Defenses
				elseif target:FindFirstChild("Humanoid") and game.Players:FindFirstChild(target.Name) then
					targetPart = target.HumanoidRootPart
					workspaceSearch = workspace -- im losing my mind
				else -- if core
					local hitbox = target:FindFirstChild("Hitbox")
					if hitbox then
						targetPart = hitbox
					end
					workspaceSearch = workspace
				end
				-- change wait time to AI attack stat
				spawn(function() while wait() do AiAttack(enemy,targetPart)  end end) -- listen... my brain is fried there is probably a better way of doing this but this works pretty well...
				if targetPart then
					local path = pathfindingService:CreatePath()
					path:ComputeAsync(enemy.HumanoidRootPart.Position, targetPart.Position)
					local points = path:GetWaypoints()
					--print(path.Status)
					if path.Status == Enum.PathStatus.Success and enemy:FindFirstChild("Pathing")  then -- and if i dont do a second check it will still bitch at me
						-- it doesnt really break the script it just clogs the output
						enemy.Pathing.Value = true
						--print(target,currentTarget.Value)
						local currentPointIndex = 1
						local distance
						local currentPoint
						local debounceRun = false
						connections = humanoid.Running:Connect(function(speed) -- hacky fix, but they dont get stuck anymore..
							if speed <= 1 and not debounceRun then
								debounceRun = true
								humanoid:MoveTo(points[currentPointIndex].Position,targetPart)
								humanoid.Jump = true
								currentPointIndex = currentPointIndex + 1
								enemy.Stuck.Value = enemy.Stuck.Value + 1
								enemy.Pathing.Value = false
								--print("told me I switched")
								wait(1)
								debounceRun = false
							end
						end)
						
						repeat 
							wait()
							if currentPointIndex < #points then -- interesting problem is this doesnt update when the enemy dies so I have to find ancestor
								--print(#points)
								currentPoint = points[currentPointIndex]
								if enemy:FindFirstChild("HumanoidRootPart") then
									distance = (enemy.HumanoidRootPart.Position - currentPoint.Position).magnitude
									
									if distance < NextPointThreshold then
										currentPointIndex = currentPointIndex + 1
									end
									
									humanoid:MoveTo(points[currentPointIndex].Position,targetPart)
									if points[currentPointIndex].Position.Y - enemy.HumanoidRootPart.Position.Y > JumpThreshold then
										humanoid.Jump = true
									end
								end
			
							end
						until not gameplayFolder.Enemies:IsAncestorOf(enemy) or currentPointIndex == #points or target.Name ~= currentTarget.Value 
						or not workspaceSearch:IsAncestorOf(target) -- if target is dead
						if gameplayFolder.Enemies:IsAncestorOf(enemy) then
							enemy.Pathing.Value = false
							connections:Disconnect()
						end
						--connections:Disconnect()
					end
				end
			end
		end
	end	
return pathModule	