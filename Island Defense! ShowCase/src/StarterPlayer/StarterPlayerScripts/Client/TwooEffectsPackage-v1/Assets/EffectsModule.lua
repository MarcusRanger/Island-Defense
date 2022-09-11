--[[
	@author: InTwoo
--]]

local effectsModule = {}
local currentEffects = {}

	local tweenService = game:GetService("TweenService")
	
--//Create label & load properties
	local function deployLabel(target, clone)
		
	end
	
--//Delete current effects
	function effectsModule.removeAllEffects()
		for i,v in pairs(currentEffects) do
			v = nil
		end
	end
--//Radiating Aura Effect
	function effectsModule.auraEffect(target, type, range, length)
		--//[!] auraVertical and AuraBoth have the same effect on images!
		
		--[[TYPES
			auraBoth -- Effect: Top, Bottom, Left, Right
			auraVertical -- Effect: Top, Bottom
			auraTop -- Effect: Top
		--]]
		
	--[Range Check]--
		if type == "auraVertical" and range < 1 then
			warn("effectsModule.auraEffect: range must be greater than 1 to work properly!")
		end
	--[!]--
		local valid
		for i, v in pairs(target.Parent:GetChildren()) do
			if v.Name == "CLONE" then
				valid = false
				break
			else
				valid = true
			end
		end
		
		if valid then
			local tweenTime
				if length == nil then
					tweenTime = 0.75 -- Default
				else
					tweenTime = length
				end
			
			local target_CLONE
			local transparencyGoal = 0.3
			local auras = 3 -- Number of radiating elements
			
			for i = 0, auras, 1 do
				if target:IsA("TextButton") then
					
					--[[CREATING LABEL]]--
					target_CLONE = Instance.new("Frame")
					target_CLONE.BackgroundColor3 = target.BackgroundColor3
					target_CLONE.Size = target.Size
					target_CLONE.Position = target.Position
					target_CLONE.BorderSizePixel = 0
					target_CLONE.ZIndex = target.ZIndex - 1
					target_CLONE.BackgroundTransparency = transparencyGoal
					target_CLONE.Parent = target.Parent
					print("STAYIN ALIVVEE111")
					target_CLONE.Name = "CLONE"
					table.insert(currentEffects,target_CLONE)
					
					--[!]--
					
					tweenService:Create(target_CLONE, TweenInfo.new(tweenTime), {BackgroundTransparency = 1}):Play()
				elseif target:IsA("ImageButton") then
--					if target.ScaleType == "Slice" then
--						warn("effectsModule.auraEffect: slicing is currently not compatible!")
--						break
--					end
					
					--[[CREATING LABEL]]--
					target_CLONE = Instance.new("ImageLabel")
					target_CLONE.BackgroundColor3 = target.BackgroundColor3
					target_CLONE.BackgroundTransparency = target.BackgroundTransparency
					target_CLONE.Size = target.Size
					target_CLONE.Position = target.Position
					target_CLONE.ScaleType = target.ScaleType
					if target.ScaleType == Enum.ScaleType.Slice then
						target_CLONE.SliceCenter = target.SliceCenter
					end
					target_CLONE.ImageTransparency = target.ImageTransparency
					target_CLONE.Image = target.Image
					target_CLONE.ImageColor3 = target.ImageColor3
					target_CLONE.BorderSizePixel = 0
					target_CLONE.ZIndex = target.ZIndex - 1
					target_CLONE.Parent = target.Parent
					target_CLONE.Name = "CLONE"
					print(target_CLONE.Name,"staying alive")
					table.insert(currentEffects,target_CLONE)
					--[!]--
					
					if target.BackgroundTransparency == 1 then
						target_CLONE.ImageTransparency = transparencyGoal
						tweenService:Create(target_CLONE, TweenInfo.new(tweenTime), {ImageTransparency = 1}):Play()
					else
						target_CLONE.BackgroundTransparency = transparencyGoal
						tweenService:Create(target_CLONE, TweenInfo.new(tweenTime), {BackgroundTransparency = 1}):Play()
					end
				end
		
				if type == "auraBoth" then
				--[X > Y CHECK]--
					if target.Size.X.Scale > target.Size.Y.Scale then
						warn("effectsModule.auraEffect[\"auraBoth\"]: Effecting Horizontal")
						print(target_CLONE," name")
						target_CLONE:TweenSizeAndPosition(UDim2.new(target.Size.X.Scale * (range * 0.8), 0, target.Size.Y.Scale * range, 0), UDim2.new(target.Position.X.Scale - (((target.Size.X.Scale * (range * 0.8)) - target.Size.X.Scale) / 2), 0, target.Position.Y.Scale - (((target.Size.Y.Scale * range) - target.Size.Y.Scale) / 2), 0), "Out", "Quart", tweenTime / 1.25, true)
					elseif target.Size.X.Scale < target.Size.Y.Scale then
						warn("effectsModule.auraEffect[\"auraBoth\"]: Effecting Vertical")
						target_CLONE:TweenSizeAndPosition(UDim2.new(target.Size.X.Scale * range, 0, target.Size.Y.Scale * (range * 0.8), 0), UDim2.new(target.Position.X.Scale - (((target.Size.X.Scale * range) - target.Size.X.Scale) / 2), 0, target.Position.Y.Scale - (((target.Size.Y.Scale * (range * 0.8)) - target.Size.Y.Scale) / 2), 0), "Out", "Quart", tweenTime / 1.25, true)
					elseif target.Size.X.Scale == target.Size.Y.Scale then
						warn("effectsModule.auraEffect[\"auraBoth\"]: Effecting Both")
						target_CLONE:TweenSizeAndPosition(UDim2.new(target.Size.X.Scale * range, 0, target.Size.Y.Scale * range, 0), UDim2.new(target.Position.X.Scale - (((target.Size.X.Scale * range) - target.Size.X.Scale) / 2), 0, target.Position.Y.Scale - (((target.Size.Y.Scale * range) - target.Size.Y.Scale) / 2), 0), "Out", "Quart", tweenTime / 1.25, true)
					end
				--[!]--
				elseif type == "auraVertical" then
					target_CLONE:TweenSizeAndPosition(UDim2.new(target.Size.X.Scale, 0, target.Size.Y.Scale * range, 0), UDim2.new(target.Position.X.Scale, 0, target.Position.Y.Scale - (((target.Size.Y.Scale * range) - target.Size.Y.Scale) / 2), 0), "Out", "Quart", tweenTime / 1.25, true)
				elseif type == "auraTop" then
					target_CLONE:TweenSizeAndPosition(UDim2.new(target.Size.X.Scale, 0, target.Size.Y.Scale * range, 0), UDim2.new(target.Position.X.Scale, 0, target.Position.Y.Scale - ((target.Size.Y.Scale * range) / 2), 0), "Out", "Quart", tweenTime / 1.25, true)
				end
				wait(0.2)
			end
			
			wait(tweenTime * 2)
			
			for i, v in pairs(target.Parent:GetChildren()) do
				if v.Name == "CLONE" then
					v:Destroy()
				end
			end
			currentEffects = nil
			currentEffects = {}
		end
	end
	
--//Middle Grow Effect
	function effectsModule.middleGrowth(target, direction, color)
		--[[DIRECTIONS
			vertical
			horizontal
			both
		--]]
		
		local tweenTime = 0.5
		
		local valid
		for i, v in pairs(target.Parent:GetChildren()) do
			if v.Name == "CLONE" then
				valid = false
				break
			else
				valid = true
			end
		end
		
		if valid then
			local target_CLONE
			if target:IsA("TextButton") then
				--[[CREATING LABEL]]--
				target_CLONE = Instance.new("Frame")
				target_CLONE.BackgroundColor3 = target.BackgroundColor3
				target_CLONE.BorderSizePixel = 0
				target_CLONE.ZIndex = target.ZIndex - 1
				target_CLONE.Parent = target
				target_CLONE.Name = "CLONE"
				table.insert(currentEffects,target_CLONE)
				--[!]--
				
				tweenService:Create(target_CLONE, TweenInfo.new(tweenTime), {BackgroundColor3 = color, BackgroundTransparency = 0.9}):Play()
			elseif target:IsA("ImageButton") then
				if target.ScaleType ~= Enum.ScaleType.Slice then
					warn("effectsModule.slideEffect: images compatible with slice only!")
				end
				--[[CREATING LABEL]]--
				target_CLONE = Instance.new("ImageLabel")
				target_CLONE.BackgroundColor3 = target.BackgroundColor3
				target_CLONE.BackgroundTransparency = target.BackgroundTransparency
				target_CLONE.ScaleType = target.ScaleType
				target_CLONE.ImageTransparency = target.ImageTransparency
				target_CLONE.Image = target.Image
				target_CLONE.ImageColor3 = target.ImageColor3
				target_CLONE.BorderSizePixel = 0
				target_CLONE.ZIndex = target.ZIndex + 1
				target_CLONE.Name = "CLONE"
				target_CLONE.ScaleType = Enum.ScaleType.Slice
				target_CLONE.SliceScale = target.SliceScale
				target_CLONE.SliceCenter = target.SliceCenter
				target_CLONE.Parent = target
				tweenService:Create(target_CLONE, TweenInfo.new(tweenTime * 2), {ImageColor3 = color, BackgroundTransparency = 1, ImageTransparency = 0.9}):Play()
				table.insert(currentEffects,target_CLONE)
			end
			
			if direction == "vertical" then
				target_CLONE.Size = UDim2.new(1, 0, 0, 0)
				target_CLONE.Position = UDim2.new(0, 0, 0.5, 0)
				target_CLONE:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quart", tweenTime * 2.5, true)
			elseif direction == "horizontal" then
				target_CLONE.Size = UDim2.new(0, 0, 1, 0)
				target_CLONE.Position = UDim2.new(0.5, 0, 0, 0)
				target_CLONE:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quart", tweenTime * 2.5, true)
			elseif direction == "both" then
				target_CLONE.Size = UDim2.new(0, 0, 0, 0)
				target_CLONE.Position = UDim2.new(0.5, 0, 0.5, 0)
				target_CLONE:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quart", tweenTime * 2.5, true)
			end
			wait(tweenTime * 2.5)
			target_CLONE:Destroy()
			currentEffects = nil
			currentEffects = {}
		end
	end
	
--//Slideover Effect
	function effectsModule.slideEffect(target, direction, color)
		--[[DIRECTIONS
			left
			right
			top
			bottom
		--]]
		local tweenTime = 0.5
		local valid
		for i, v in pairs(target.Parent:GetChildren()) do
			if v.Name == "CLONE" then
				valid = false
				break
			else
				valid = true
			end
		end
		
		if valid then
			local target_CLONE
			
			if target:IsA("TextButton") then
				--[[CREATING LABEL]]--
				target_CLONE = Instance.new("Frame")
				target_CLONE.BackgroundColor3 = target.BackgroundColor3
				target_CLONE.BorderSizePixel = 0
				target_CLONE.ZIndex = target.ZIndex - 1
				target_CLONE.Parent = target
				target_CLONE.Name = "CLONE"
				table.insert(currentEffects,target_CLONE)
				--[!]--
				
				tweenService:Create(target_CLONE, TweenInfo.new(tweenTime), {BackgroundColor3 = color, BackgroundTransparency = 0.9}):Play()
			elseif target:IsA("ImageButton") then
				if target.ScaleType ~= Enum.ScaleType.Slice then
					warn("effectsModule.slideEffect: images compatible with slice only!")
				end
				--[[CREATING LABEL]]--
				target_CLONE = Instance.new("ImageLabel")
				target_CLONE.BackgroundColor3 = target.BackgroundColor3
				target_CLONE.BackgroundTransparency = target.BackgroundTransparency
				target_CLONE.ScaleType = target.ScaleType
				target_CLONE.ImageTransparency = target.ImageTransparency
				target_CLONE.Image = target.Image
				target_CLONE.ImageColor3 = target.ImageColor3
				target_CLONE.BorderSizePixel = 0
				target_CLONE.ZIndex = target.ZIndex + 1
				target_CLONE.Name = "CLONE"
				target_CLONE.ScaleType = Enum.ScaleType.Slice
				target_CLONE.SliceScale = target.SliceScale
				target_CLONE.SliceCenter = target.SliceCenter
				target_CLONE.Parent = target
				tweenService:Create(target_CLONE, TweenInfo.new(tweenTime * 2), {ImageColor3 = color, BackgroundTransparency = 1, ImageTransparency = 0.9}):Play()
				table.insert(currentEffects,target_CLONE)
			end
			
			if direction == "left" then
				target_CLONE.Size = UDim2.new(0, 0, 1, 0)
				target_CLONE.Position = UDim2.new(1, 0, 0, 0)
				target_CLONE:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quart", tweenTime * 2.5, true)
			elseif direction == "right" then
				target_CLONE.Size = UDim2.new(0, 0, 1, 0)
				target_CLONE.Position = UDim2.new(0, 0, 0, 0)
				target_CLONE:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quart", tweenTime * 2.5, true)
			elseif direction == "top" then
				target_CLONE.Size = UDim2.new(1, 0, 0, 0)
				target_CLONE.Position = UDim2.new(0, 0, 0, 0)
				target_CLONE:TweenSize(UDim2.new(1, 0, 1, 0), "Out", "Quart", tweenTime * 2.5, true)
			elseif direction == "bottom" then
				target_CLONE.Size = UDim2.new(1, 0, 0, 0)
				target_CLONE.Position = UDim2.new(0, 0, 1, 0)
				target_CLONE:TweenSizeAndPosition(UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), "Out", "Quart", tweenTime * 2.5, true)
			end
			wait(tweenTime * 2.5)
			target_CLONE:Destroy()
			currentEffects = nil
			currentEffects = {}
		end
	end
return effectsModule