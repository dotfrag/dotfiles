-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- vim.keymap.set("i", "<C-h>", "<Left>")
-- vim.keymap.set("i", "<C-j>", "<Down>")
-- vim.keymap.set("i", "<C-k>", "<Up>")
-- vim.keymap.set("i", "<C-l>", "<Right>")

vim.keymap.set("n", "<leader>d", function()
  require("mini.bufremove").delete(0, false)
end, { desc = "Delete Buffer" })

vim.keymap.set("n", "<leader>snt", "<cmd>NoiceTelescope<cr>", { desc = "Noice Telescope" })
