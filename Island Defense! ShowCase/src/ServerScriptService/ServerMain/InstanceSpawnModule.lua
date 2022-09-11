
--[[
	@author: marcusc123
	-- hooks instances to respected functions
--]]
local CollectionService = game:GetService("CollectionService")

--CollectionService:AddTag(object,"Enemy")

local pathfindingService = game:GetService("PathfindingService")
local PhysicsService = game:GetService("PhysicsService")

local ReplicatedStorage = game.ReplicatedStorage

local defense = workspace.Gameplay.Defenses
local enemy = workspace.Gameplay.Enemies

local connections = {}
local instanceModule = {Acquire = nil}

   function instanceModule.onEnemyInstanceAdded(object)
	local pathModule = instanceModule.Acquire["PathfindingModule"]

    	if object:FindFirstChild("Humanoid") then
			object.Humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing, false)
			for _,v in pairs(object:GetChildren()) do
		        if v:IsA("BasePart") or v:IsA("MeshPart") then   
					PhysicsService:SetPartCollisionGroup(v, "AiGroup")
				end
			end
			
			local hpGui = object.Head.HPGui
			local healthMax = object.health.Value
			object.Humanoid.MaxHealth = healthMax
			object.Humanoid.Health = healthMax
			hpGui.HealthText.Text = tostring(healthMax) .. "/" .. healthMax
			connections[object] = object.Humanoid.Died:Connect(function()
				object:Destroy()
			end)
			connections[object] = object.Humanoid.HealthChanged:Connect(function(value)
				local hpGui = object.Head.HPGui
				local healthMax = object.health.Value
				hpGui.HealthText.Text = tostring(value) .. "/" .. healthMax
				hpGui.Health:TweenSize(UDim2.new(value/healthMax, 0, 1, 0), "Out", "Quart", 0.2, true)
				if value <= 0 then -- when testing I noticed some mobs are still alive after "dying" this might be the fix
					object:Destroy()
				end
			end)
			
			spawn(function()
				while wait(.18) do
					if enemy:IsAncestorOf(object) then
						pathModule.getClosest(object) 
					else 
						--print("OH WOW YOURE")
						break
					end
				end
			end)
			
			spawn(function()
				pathModule.getSpecialMove(object)
			end)
    	end
    end

    function instanceModule.onTurretInstanceAdded(object)
		local targetModule = instanceModule.Acquire["TargetfindingModule"]
		local defenseModule = instanceModule.Acquire["DefenseModule"]
    	if object:FindFirstChild("Turret") then
			CollectionService:AddTag(object,"Target")
			for _,v in pairs(object:GetChildren()) do
		        if v:IsA("BasePart") then   
					PhysicsService:SetPartCollisionGroup(v, "AiGroup")
				end
			end
			local owner = game.Players:FindFirstChild(object.playertag.Value.Name)
			if owner then
				
				spawn(function()
					while wait(.25) do
						if defense:IsAncestorOf(object) then
							targetModule.getClosest(object) 
						else
							break
						end
					end
				end)
				local hpGui = object.Healthbar.HPGui
				local healthMax = object.MaxHealth.Value
				hpGui.HealthText.Text = tostring(healthMax) .. "/" .. healthMax
				
				connections[object] = object.Health.Changed:Connect(function(health)
					if health <= 0 then
						defenseModule.RemoveDefense(object.playertag.Value,object)
					end
				end)
				connections[object] = object.Health.Changed:Connect(function(value)
					local hpGui = object.Healthbar.HPGui
					local healthMax = object.MaxHealth.Value
					hpGui.HealthText.Text = tostring(value) .. "/" .. healthMax
					hpGui.Health:TweenSize(UDim2.new(value/healthMax, 0, 1, 0), "Out", "Quart", 0.2, true)
				end)
				
				connections[object] = owner.CharacterRemoving:Connect(function(character) -- dont want to call PlayerRemoving on every instance, will call even if the target player doenst leave
				
					local player = game.Players:GetPlayerFromCharacter(character) -- THIS INSTANCE IS STILL CAPTURED 
					local playerFinder = game.Players:FindFirstChild(player) -- WHILE THIS ONE IS NOT, WE CHECK USING THIS 
					if not playerFinder then -- if player left the match
						defenseModule.RemoveDefense(object.playertag.Value,object)
					end
				end)
			end 
    	end
    end
     
   function instanceModule.onInstanceRemoved(object) -- when turret is removed from anysource this is called
		local defenseModule = instanceModule.Acquire["DefenseModule"]
		local aiModule = instanceModule.Acquire["AiModule"]
		if object:FindFirstChild("Turret") then
 			--defenseModule.RemoveDefense(object.playertag.Value,object)
		elseif object:FindFirstChild("Humanoid") then
			local tagged = object:FindFirstChild("Tagged")
			if tagged then			
				aiModule.defenseKillTracker(tagged.Value,object)
			end
		end
    	if connections[object] then
    		connections[object]:disconnect()
    		connections[object] = nil
    	end
    end


    CollectionService:GetInstanceAddedSignal("Enemy"):Connect(instanceModule.onEnemyInstanceAdded)
	CollectionService:GetInstanceRemovedSignal("Enemy"):Connect(instanceModule.onInstanceRemoved)
	
	CollectionService:GetInstanceAddedSignal("Turret"):Connect(instanceModule.onTurretInstanceAdded)
	CollectionService:GetInstanceRemovedSignal("Turret"):Connect(instanceModule.onInstanceRemoved)
     
    -- for anything already tagged
    for _, object in pairs(CollectionService:GetTagged("Enemy")) do
    	instanceModule.onEnemyInstanceAdded(object)
    end

	for _, object in pairs(CollectionService:GetTagged("Turret")) do
    	instanceModule.onEnemyInstanceAdded(object)
    end
return instanceModule