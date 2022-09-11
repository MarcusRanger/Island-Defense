
local Humanoid = script.Parent:WaitForChild("Humanoid")

local ServerStorage = game:GetService("ServerStorage")
local Give = ServerStorage.Give

Humanoid.Died:Connect(function()
	
	local Creator = Humanoid:FindFirstChild("creator")
	
	if Creator then
		
		Give:Fire(1, Creator.Value)
		
	end
	
end)
