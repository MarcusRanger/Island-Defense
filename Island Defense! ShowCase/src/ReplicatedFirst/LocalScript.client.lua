repeat wait(1) until game:IsLoaded() 

local ReplicatedFirst = game:GetService("ReplicatedFirst")
local Yield = game:GetService("RunService").RenderStepped
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,false)
game.ReplicatedFirst:RemoveDefaultLoadingScreen()

local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
PlayerGui:SetTopbarTransparency(0)

local IntroGui = ReplicatedFirst:WaitForChild("Intro"):Clone()
IntroGui.Parent = PlayerGui

local Messages = {
	"Please watchout for those dangerous Bombs", 
	"Dont forget to like the game and favorite it",
	"Tons more enemies ready to fight will be added soon so stay tuned!!!",
	"DoubleHQ is awesome!!!",
	"We pirates are the strongest enemies ever RRRR!!",
	"More updates will be soon added",
	"Dont forget to save before leaving",
	"The boss will be waiting ready to hunt you all",
	"Keep fighting to protect your island"
}

local Head = IntroGui:WaitForChild("Head")
local Rotation = 60
local Start = tick()

local LoadingBar = IntroGui:WaitForChild("LoadingBar")
local Message = IntroGui:WaitForChild("Message")

local LoadingMusic = IntroGui:WaitForChild("LoadingMusic"):Clone()
LoadingMusic.Parent = game.Soundscape
LoadingMusic:Play()

spawn(function()
	while tick()- Start < 15 do
		
		if math.floor(tick() - Start) == 12 then
			Message.Text = "Loading all assets"
		elseif math.floor(tick() - Start) == 14 then
			Message.Text = "Data found!!"
		else
			local Text = math.random(1,#Messages)
			Message.Text = Messages[Text]
			table.remove(Messages,Text)
		end
		wait(2)
	end
end)

while tick()- Start < 15 do
	local Tween = TweenService:Create(Head,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,true,0),{Position = UDim2.new(0.5,0,0.32,0),Rotation = Rotation})
	Tween:Play()
	
	local Tween = TweenService:Create(LoadingBar,TweenInfo.new(0.5,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,true,0),{Size = UDim2.new(0.18, 0,0.001, 0)})
    Tween:Play()
	
	local Bop = game.Soundscape:WaitForChild("Bop")
	Bop:Play()
	if Rotation == 60 then
		Rotation = -60
	else
		Rotation = 60
	end
	wait(1)
end

local Tween = TweenService:Create(LoadingBar,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),{BackgroundTransparency = 1})
Tween:Play()
local Tween = TweenService:Create(Head,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),{ImageTransparency = 1})
Tween:Play()
local Tween = TweenService:Create(Message,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),{TextTransparency = 1})
Tween:Play()
local Loading = IntroGui:WaitForChild("Loading")
local Tween = TweenService:Create(Loading,TweenInfo.new(0.8,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),{TextTransparency = 1})
Tween:Play()
local Tween = TweenService:Create(LoadingMusic,TweenInfo.new(0.1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),{Volume = 0})
Tween:Play()
wait(2)

local GroupLogo = IntroGui:WaitForChild("GroupLogo")
local Tween = TweenService:Create(GroupLogo,TweenInfo.new(1.5,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),{ImageTransparency = 0})
Tween:Play()

local Sound = IntroGui:WaitForChild("Sound"):Clone()
Sound.Parent = game.Soundscape
Sound:Play()

GroupLogo:TweenSize(UDim2.new(0.146, 0,0.317, 0),"Out","Quart",1.5)
wait(3.5)

local Tween = TweenService:Create(GroupLogo,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),{ImageTransparency = 1})
Tween:Play()
wait(2.2)

local Background = IntroGui:WaitForChild("Background")
local Tween = TweenService:Create(Background,TweenInfo.new(0.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0),{BackgroundColor3 = Color3.fromRGB(255,255,255)})
Tween:Play()
wait(1)

GroupLogo:TweenPosition(UDim2.new(0.5, 0,0.9, 0),"Out","Quint",0.5)

local MediumWooshSound = IntroGui:WaitForChild("MediumWoosh"):Clone()
MediumWooshSound.Parent = game.Soundscape
MediumWooshSound:Play()
local GameLogo = IntroGui:WaitForChild("GameLogo")
GameLogo:TweenSize(UDim2.new(0.293, 0,0.638, 0),"Out","Back",0.5)
wait(1.5)

local LongWooshSound = IntroGui:WaitForChild("LongWoosh"):Clone()
LongWooshSound.Parent = game.Soundscape
LongWooshSound:Play()
local Tween = TweenService:Create(GameLogo,TweenInfo.new(1.8,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{ImageTransparency = 1})
Tween:Play()

wait(2)

local Tween = TweenService:Create(Background,TweenInfo.new(1,Enum.EasingStyle.Quint,Enum.EasingDirection.Out,0,false,0),{Transparency = 1})
Tween:Play()

local Tween = TweenService:Create(Sound,TweenInfo.new(1,Enum.EasingStyle.Linear,Enum.EasingDirection.Out,0,false,0),{Volume = 0})
Tween:Play()

LongWooshSound:Destroy()
MediumWooshSound:Destroy()
IntroGui:Destroy()
wait(1.5)
Sound:Destroy()

StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All,false)