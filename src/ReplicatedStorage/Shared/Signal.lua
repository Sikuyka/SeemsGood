--!strict
--[[ Signal.lua — lightweight event implementation. docs/modules/Signal.md ]]

local Signal = {}
Signal.__index = Signal

export type Connection = { Disconnect: (self: Connection) -> () }
export type SignalInstance = typeof(setmetatable({} :: any, Signal))

function Signal.new(): SignalInstance
	return setmetatable({ _bindable = Instance.new("BindableEvent"), _connections = {} }, Signal)
end

function Signal:Connect(fn: (...any) -> ()): Connection
	local conn = self._bindable.Event:Connect(fn)
	table.insert(self._connections, conn)
	return {
		Disconnect = function()
			conn:Disconnect()
		end,
	}
end

function Signal:Fire(...: any)
	self._bindable:Fire(...)
end

function Signal:Destroy()
	for _, c in self._connections do
		c:Disconnect()
	end
	self._bindable:Destroy()
end

return Signal
