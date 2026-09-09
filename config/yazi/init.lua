require("full-border"):setup()
require("session"):setup({
	sync_yanked = true,
})

-- https://github.com/sxyazi/yazi/discussions/4298#discussioncomment-18181077
km.mgr.rules:insert(1, {
	on = { "g", "H" },
	run = string.format("cd -- %s", fs.cwd()),
	desc = "Go back to where I started",
})
