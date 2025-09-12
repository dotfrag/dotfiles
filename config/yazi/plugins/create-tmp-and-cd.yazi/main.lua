--- @sync entry

local function entry()
	-- can't figure out how to use yazi's Command() 🤷
	local handle = io.popen("mktemp -d")
	if not handle then
		ya.notify({
			title = "mktempcd",
			content = "Failed to run mktemp",
			timeout = 3,
			level = "error",
		})
		return
	end

	local dirname = handle:read("*l")
	handle:close()

	ya.emit("cd", { dirname })
end

return { entry = entry }
