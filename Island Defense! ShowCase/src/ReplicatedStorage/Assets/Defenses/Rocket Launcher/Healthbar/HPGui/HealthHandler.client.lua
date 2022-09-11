script.Parent.Parent.Parent.Health.Changed:Connect(function()
	script.Parent.Health = script.Parent.Parent.Parent.Health.Value .. "/" .. script.Parent.Parent.Parent.MaxHealth.Value
	script.Parent.Health:TweenSize(UDim2.new(script.Parent.Parent.Parent.Health.Value / script.Parent.Parent.Parent.MaxHealth.Value, 0, 1, 0, "Out", "Quart", 0.1, true))
end)