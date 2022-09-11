local Camera = {Acquire = nil}
	local TweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(.8,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0)
	local currentCamera = workspace.CurrentCamera
	local player = game.Players.LocalPlayer
	local viewPlayer = 1
	--make it so that we cant spectate our player
	local function getPlayerSubject(value)
		local players = game.Players:GetPlayers()
		for i,removePlayer in pairs(players) do -- dont want to spectate our own player
			if removePlayer == player then
				table.remove(players,i)
			end
		end
		viewPlayer = viewPlayer + value
		if viewPlayer > #players then
			viewPlayer = 1
		elseif viewPlayer < 1 then
			viewPlayer = #players -- this way the player can spam either arrow to rotate throughout the players
		end
		if #players == 0 then
			return "",nil
		else
			local name,humanoid = players[viewPlayer].Name,players[viewPlayer].Character:FindFirstChild("Humanoid")
			if humanoid then
				return name,humanoid
			end
		end
	end
	--[[
	function Camera.tweenCamera(goalPart)
		
	end
	--]]
	function Camera.pointToTarget(targetPart) 
		currentCamera.CameraType = Enum.CameraType.Scriptable
		local goal = {CFrame = targetPart.CFrame} -- change to the target part
		local Animation = TweenService:Create(currentCamera,tweenInfo,goal)
		Animation:Play()
	end
	
	function Camera.subjectChange(subject)
		currentCamera.CameraType = Enum.CameraType.Custom
		currentCamera.CameraSubject = subject
	end
	
	function Camera.originalSubject()
		currentCamera.CameraType = Enum.CameraType.Custom
		local humanoid = player.Character:FindFirstChild("Humanoid")
		if humanoid then
			currentCamera.CameraSubject = humanoid
		end
	end
	
	function Camera.spectateNextPlayer()
		local name,humanoid = getPlayerSubject(1)
		if humanoid then
			Camera.subjectChange(humanoid)
		end
		return name
	end
	
	function Camera.spectatePreviousPlayer()
		local name,humanoid = getPlayerSubject(-1)
		Camera.subjectChange(humanoid)
		return name
	end

return Camera
