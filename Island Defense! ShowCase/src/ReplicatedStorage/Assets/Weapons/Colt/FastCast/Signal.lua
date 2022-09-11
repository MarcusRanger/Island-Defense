--[[
	Creates signals via a modulized version of RbxUtility's Lua-ified RBXScriptSignal object.
	(RbxUtility was deprecated by roblox, so this will be released as an alternative for people who would like to keep using it while allowing it to retain a modulized form)
	
	This creates RBXScriptSignals in a lua representation. An RBXScriptSignal is the object returned when you use the :Connect(...) event on some object.
	
	TO CREATE AN EVENT:
		Signal (table) Module:CreateNewSignal() 
			> Similarly to roblox, as mentioned above, an event can have its :Connect(...) function called to create a script signal. This function does so.
	
	API OFFERED BY SIGNAL:
		table Signal:Connect(Function f)
			> Runs the function "f" when this event fires. The table returned is a custom RBXScriptSignal.
			> The signal returned has a :Disconnect() function that will disconnect your function from the event.
			
		void Signal:Wait()
			> Yields until this event has been fired.
			
		void Signal:DisconnectAll()
			> Disconnects ALL registered connections (created via :Connect(...)) to this signal.
			
		void Signal:Fire(Tuple args) --Cause the event to fire with your own arguments
			> Fire this signal. The arguments you input will be passed into the function given to :Connect(...)		
		
	Standard creation:
	
		local SignalModule = require(this_module)
		local Signal = SignalModule:CreateNewSignal()
		
		function OnEvent()
			print("Event fired!")
		end
		
		Signal:Connect(OnEvent) --Connect the event to the function above.
		
		Signal:Fire() --Fire the event.
--]]

local Signal = {}

function Signal:CreateNewSignal()
	local This = {}

	local mBindableEvent = Instance.new("BindableEvent")
	local mAllCns = {} --All connection objects returned by mBindableEvent::connect

	function This:Connect(Func)
		if typeof(Func) ~= "function" then
			error("Argument #1 of Connect must be a function, got a ".. typeof(Func), 2)
		end
		local Con = mBindableEvent.Event:Connect(Func)
		mAllCns[Con] = true
		local ScrSig = {}
		function ScrSig:Disconnect()
			Con:Disconnect()
			mAllCns[Con] = nil
		end
				
		return ScrSig
	end
	
	function This:DisconnectAll()
		for Connection, _ in pairs(mAllCns) do
			Connection:Disconnect()
			mAllCns[Connection] = nil
		end
	end
	
	function This:Wait()
		return mBindableEvent.Event:Wait()
	end
	
	function This:Fire(...)
		mBindableEvent:Fire(...)
	end
	
	return This
end

return Signal