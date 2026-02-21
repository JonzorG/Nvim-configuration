-- ==========================================
-- AUTOMATION & LOGIC
-- ==========================================

-- SPELLING: Enable spellcheck for text files
vim.api.nvim_create_autocmd("FileType", {
	pattern = "text",
	callback = function()
		vim.opt_local.spell = true
		vim.opt_local.spelllang = "en_us"
	end,
})

-- UI FIXES: Ensure line number colors are correct
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#E0AF68", bold = true })
		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#51B3EC", bold = true })
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff", bold = true })

		vim.api.nvim_set_hl(0, "Folded", { bg = "NONE", fg = "#565f89", italic = true })
	end,
})

-- REMEMBER FOLDER: Auto-save your last location
local function save_cwd_to_file()
	local cwd = vim.fn.getcwd()
	local file = io.open(os.getenv("HOME") .. "/.nvim_last_dir", "w")
	if file then
		file:write(cwd)
		file:close()
	end
end

vim.api.nvim_create_autocmd({ "DirChanged", "VimLeavePre" }, {
	callback = save_cwd_to_file,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = "*",
	callback = function()
		local path = vim.fn.expand("%:p:h")
		if vim.fn.isdirectory(path) == 1 then
			vim.api.nvim_set_current_dir(path)
		end
	end,
})

vim.api.nvim_create_autocmd("BufEnter", {
	pattern = { "*.png", "*.jpg", "*.jpeg", "*.pdf", "*.gif" },
	callback = function()
		local file = vim.fn.expand("%")
		vim.fn.jobstart({ "xdg-open", file }, { detach = true })
		vim.api.nvim_buf_delete(0, {})
	end,
})
