local map = vim.keymap.set

-- ==========================================================
-- 🪟 WINDOW & NAVIGATION
-- ==========================================================
map("n", "<C-j>", "<C-e>", { desc = "Window: Scroll Down" })
map("n", "<C-k>", "<C-y>", { desc = "Window: Scroll Up" })
map("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- ==========================================================
-- 📝 TEXT MANIPULATION
-- ==========================================================
-- Move Lines (Alt + j/k)
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move Line Down", silent = true })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move Line Up", silent = true })
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", { desc = "Move Line Down (Insert)", silent = true })
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", { desc = "Move Line Up (Insert)", silent = true })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move Block Down (Visual)", silent = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move Block Up (Visual)", silent = true })

-- Clipboard: Yanking
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to System Clipboard" })
map("n", "<leader>yy", [["+yy]], { desc = "Yank Line to System Clipboard" })
map("n", "<leader>ya", "<cmd>silent %y<cr>", { desc = "Yank Whole File (Nvim)" })
map("n", "<leader>yA", "<cmd>silent %y +<cr>", { desc = "Yank Whole File (System)" })

-- Clipboard: Pasting
map({ "n", "v" }, "<leader>p", [["+p]], { desc = "Paste System Clipboard (After)" })
map({ "n", "v" }, "<leader>bp", [["+P]], { desc = "Paste System Clipboard (Before)" })
map("i", "<C-v>", "<C-r>+", { desc = "Paste System Clipboard (Insert Mode)" })
map("n", "<leader>P", 'ggVG"+p', { noremap = true, desc = "Replace all with clipboard" })

-- Spelling
map("n", "<leader>sc", function()
	vim.wo.spell = not vim.wo.spell
	vim.notify("Spell Check: " .. (vim.wo.spell and "On" or "Off"))
end, { desc = "Toggle Spell Check" })

map("n", "<leader>sl", function()
	local current = vim.bo.spelllang
	local new_lang = "en_us"

	if current == "en_us" then
		new_lang = "sv"
	elseif current == "sv" then
		new_lang = "en_us,sv"
	end

	vim.bo.spelllang = new_lang
	vim.notify("Spell Lang: " .. string.upper(new_lang), vim.log.levels.INFO)
end, { desc = "Cycle Spell Language (EN -> SV -> Both)" })

local function spell_jump_and_suggest(direction)
	-- 1. Jump to the word and perfectly center the screen
	vim.cmd("normal! " .. direction .. "szz")

	-- 2. Grab buffer, cursor position, and the word itself
	local bufnr = vim.api.nvim_get_current_buf()
	local word = vim.fn.expand("<cword>")
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1], cursor[2]

	-- 3. Apply a high-contrast highlight (using the built-in 'Search' group)
	local ns = vim.api.nvim_create_namespace("SpellTarget")
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
	pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, row - 1, col, {
		end_col = col + #word,
		hl_group = "Search",
	})

	-- 4. Open Telescope
	require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({ initial_mode = "normal" }))

	-- 5. Auto-clear the highlight the moment you resolve it or move
	vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "WinEnter" }, {
		buffer = bufnr,
		once = true,
		callback = function()
			pcall(vim.api.nvim_buf_clear_namespace, bufnr, ns, 0, -1)
		end,
	})
end

map("n", "<leader>sn", function()
	spell_jump_and_suggest("]")
end, { desc = "Spelling: Jump to next & suggest" })
map("n", "<leader>sp", function()
	spell_jump_and_suggest("[")
end, { desc = "Spelling: Jump to prev & suggest" })

-- ==========================================================
-- 🛠️ NATIVE DIAGNOSTICS & EDITING
-- ==========================================================
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Diagnostics: Show Line" })
map("n", "<F2>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "LSP: Rename Symbol Globally" })

-- ==========================================================
-- 🚫 HARD MODE: Disable Arrow Keys
-- ==========================================================
map({ "n", "i", "v" }, "<Up>", "<Nop>", { desc = "Disable Up Arrow" })
map({ "n", "i", "v" }, "<Down>", "<Nop>", { desc = "Disable Down Arrow" })
map({ "n", "i", "v" }, "<Left>", "<Nop>", { desc = "Disable Left Arrow" })
map({ "n", "i", "v" }, "<Right>", "<Nop>", { desc = "Disable Right Arrow" })
