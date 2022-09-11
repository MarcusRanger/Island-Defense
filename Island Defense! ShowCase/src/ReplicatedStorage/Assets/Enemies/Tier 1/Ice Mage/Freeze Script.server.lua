

local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local newRandom = Random.new()

function createIceShard(target)
    local iceShard = game.ServerStorage.IceShard:Clone()
    iceShard.CFrame = CFrame.new(script.Parent.HumanoidRootPart.Position, target.Position)
    iceShard.Parent = workspace
    
    local BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
    BodyVelocity.Velocity = iceShard.CFrame.LookVector * 50
    BodyVelocity.Parent = iceShard
    
    Debris:AddItem(iceShard, 4)
    
    return iceShard
end

local CastAnim = Instance.new("Animation")
CastAnim.Name = "CastAnim"
CastAnim.Parent = script.Parent
CastAnim.AnimationId = "rbxassetid://03024303655"

--[[local AnimationController = Instance.new("AnimationController")
AnimationController.Parent = script.Parent]]

local Track = script.Parent.Humanoid:LoadAnimation(CastAnim)
Track.Looped = false

while wait(5) do
    for i, v in pairs(game.Players:GetChildren()) do
        if v.Character and v.Character:FindFirstChild("Humanoid") and (script.Parent:WaitForChild("HumanoidRootPart").Position - v.Character.HumanoidRootPart.Position).magnitude <= 128 and not v.Character:FindFirstChild("Frozen") then
            Track:Play()
--print("Play")
			wait(.3)
            local iceShard = createIceShard(v.Character.HumanoidRootPart)
    
            iceShard.Touched:Connect(function(hit)
                if hit.Parent:FindFirstChild("Humanoid") and hit.Parent.Parent ~= workspace.Enemies and not hit.Parent:FindFirstChild("Frozen") then
                    
					local obj = Instance.new("BoolValue")
					obj.Name = "Frozen"
					obj.Parent = hit.Parent

                    hit.Parent.Humanoid:TakeDamage(32) 

                    iceShard:Destroy()
                    hit.Parent.Humanoid.WalkSpeed = 0
                    hit.Parent.Humanoid.JumpPower = 0

                    local iceRock = game.ServerStorage.IceRock:Clone()
                    iceRock.CFrame = hit.Parent.HumanoidRootPart.CFrame
                    iceRock.Parent = workspace
                    iceRock.Sound:Play() -- you can change 'Sound' to whatever you name the sound
                    Debris:AddItem(iceRock, 5)

                    wait(5)
                    hit.Parent.Humanoid.WalkSpeed = 13
                    hit.Parent.Humanoid.JumpPower = 55
					obj:Destroy()
                end
            end)
        end
    end
end