-- Handles function calls. Basically just makes sure we're enabled before doing anything.
function bsync.queue_func(func, ...)
	if bsync.enabled then
		func(unpack(arg))
	end
end