local function entry()
	local output, err = Command("mktemp"):arg("-d"):output()

	if not output then
		ya.notify({
			title = "mktempcd",
			content = "Failed to run mktemp: " .. tostring(err),
			timeout = 3,
			level = "error",
		})
		return
	end

	-- Trim trailing newline/whitespace from stdout
	local dirname = output.stdout:gsub("%s+$", "")

	if dirname ~= "" then
		ya.emit("cd", { dirname })
	end
end

return { entry = entry }
