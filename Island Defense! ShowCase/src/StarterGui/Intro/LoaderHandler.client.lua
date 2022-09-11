script.Parent.Enabled = true
script.Parent.Parent.ScreenUI.Enabled = true
local blur = game:GetService("Lighting").Blur
blur.Enabled = true
blur.Size = 24
wait(2)
script.Parent.Holder.FillerHolder:TweenSize(UDim2.new(1, 0, 0, 0), "Out", "Sine", 8, true)
script.Parent.LoadingBar.Background.Filler:TweenSize(UDim2.new(1,0,1,0), "Out", "Sine", 8, true)
wait(8)
script.Parent.LoadingBar.Background.Loading.Text = "ASSETS LOADED!"
wait(2)
script.Parent.Holder:TweenPosition(UDim2.new(0.261, 0, -0.9, 0), "In", "Back", 1, true)
script.Parent.LoadingBar:TweenPosition(UDim2.new(0.2, 0, 1.2, 0), "In", "Back", 1, true)

wait(1.1)
script.Parent.Enabled = false
for i = 24, 0, -1 do
	blur.Size = i
	wait(0.05)
end
blur.Enabled = false

script.Parent.Enabled = false
script.Parent:Destroy()