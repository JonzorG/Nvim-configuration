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
		vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#bb9af7", bold = true })

		vim.api.nvim_set_hl(0, "Folded", { bg = "NONE", fg = "#565f89", italic = true })

		-- TREESITTER CONTEXT FIXES
		vim.api.nvim_set_hl(0, "TreesitterContext", { bg = "NONE" })
		vim.api.nvim_set_hl(0, "TreesitterContextLineNumber", { fg = "#E0AF68", bg = "NONE", bold = true })
		vim.api.nvim_set_hl(0, "TreesitterContextBottom", { sp = "#565f89", underline = true })
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
	pattern = { "*.png", "*.jpg", "*.jpeg", "*.pdf", "*.gif", "*.pcapng", "*.docx", "*.epub", "*.svg", "*.fits" },
	callback = function(args)
		local file = vim.api.nvim_buf_get_name(args.buf)
		vim.ui.open(file)

		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(args.buf) then
				vim.api.nvim_buf_delete(args.buf, { force = true })
			end
		end)
	end,
})

-- DISABLE AUTO-COMMENTS: Stop newline continuation of comments
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt.formatoptions:remove({ "c", "r", "o" })
	end,
})

local csv_group = vim.api.nvim_create_augroup("UserCsvView", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
	group = csv_group,
	pattern = { "csv", "tsv" },
	callback = function()
		pcall(function()
			vim.cmd("CsvViewEnable")
		end)
	end,
	desc = "Automatically enable csvview.nvim for spreadsheet files",
})

-- HIGHLIGHT YANK & CLIPBOARD NOTIFICATION
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("HighlightYank", { clear = true }),
	callback = function()
		vim.api.nvim_set_hl(0, "WhiteYank", { bg = "#ffffff", fg = "#000000", bold = true })
		vim.highlight.on_yank({ higroup = "WhiteYank", timeout = 100 })

		local reg = vim.v.event.regname
		if reg == "+" or reg == "*" then
			vim.notify("Copied to system clipboard", vim.log.levels.INFO, { title = "Clipboard" })
		elseif reg == "" or reg == '"' then
			vim.notify("Copied to Nvim clipboard", vim.log.levels.INFO, { title = "Clipboard" })
		end
	end,
})
