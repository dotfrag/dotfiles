local paths = {
	"/tmp/",
}

mp.register_event("file-loaded", function()
	local path = mp.get_property("path", "")
	for _, prefix in ipairs(paths) do
		if path:find(prefix) then
			mp.set_property("fullscreen", "yes")
			break
		end
	end
end)
