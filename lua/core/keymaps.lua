local map = vim.keymap.set

-- ==========================================================
-- 🪟 WINDOW & NAVIGATION
-- ==========================================================
map("n", "<C-j>", "<C-e>", { desc = "Window: Scroll Down" })
map("n", "<C-k>", "<C-y>", { desc = "Window: Scroll Up" })

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

-- ==========================================================
-- 🔍 TELESCOPE & SEARCH
-- ==========================================================
local function tel(builtin)
	return function()
		require("telescope.builtin")[builtin]()
	end
end

-- Core Finders
map("n", "<leader>ff", tel("find_files"), { desc = "Search: Files in Root" })
map("n", "<leader>fg", tel("live_grep"), { desc = "Search: Text (Grep)" })
map("n", "<leader>fb", tel("buffers"), { desc = "Search: Open Buffers" })
map("n", "<leader>sr", function()
	require("telescope.builtin").registers({ initial_mode = "normal" })
end, { desc = "Search: Registers" })
map("n", "<leader>sk", tel("keymaps"), { desc = "Search: Keymap Definitions" })

-- Custom Paths
map("n", "<leader>fc", function()
	require("telescope.builtin").find_files({ cwd = os.getenv("HOME") .. "/.config/nvim" })
end, { desc = "Search: Neovim Config Files" })
map("n", "<leader>fr", function()
	require("telescope.builtin").find_files({ cwd = os.getenv("HOME") .. "/Documents" })
end, { desc = "Search: Documents Directory" })

-- ==========================================================
-- 🛠️ LSP & DIAGNOSTICS
-- ==========================================================
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "LSP: Show Line Diagnostics" })
map("n", "<leader>sd", function()
	require("telescope.builtin").diagnostics({ initial_mode = "normal" })
end, { desc = "Search: Diagnostics" })
map("n", "<leader>ss", tel("lsp_document_symbols"), { desc = "Search: Document Symbols" })
map("n", "z=", function()
	require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({ initial_mode = "normal" }))
end, { desc = "LSP: Spell Suggestions (Cursor)" })
map("n", "<F2>", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "LSP: Rename Symbol Globally" })

-- ==========================================================
-- 🎨 UI & TOOLS
-- ==========================================================
map("n", "<leader>db", "<cmd>DBUIToggle<CR>", { desc = "Tool: Toggle Database UI" })
map("n", "<leader>th", function()
	require("telescope.builtin").colorscheme({ enable_preview = true })
end, { desc = "UI: Switch Theme (Live Preview)" })

map("n", "<leader>tc", "<cmd>CsvViewToggle<CR>", { desc = "Toggle CSV View" })

-- ==========================================================
-- 📌 TODO COMMENTS
-- ==========================================================
map("n", "]t", function()
	require("todo-comments").jump_next()
end, { desc = "Jump to Next TODO" })
map("n", "[t", function()
	require("todo-comments").jump_prev()
end, { desc = "Jump to Previous TODO" })
map("n", "<leader>st", "<cmd>TodoTelescope<cr>", { desc = "Search: TODO Comments" })

-- ==========================================================
-- 🚫 HARD MODE: Disable Arrow Keys
-- ==========================================================
map({ "n", "i", "v" }, "<Up>", "<Nop>", { desc = "Disable Up Arrow" })
map({ "n", "i", "v" }, "<Down>", "<Nop>", { desc = "Disable Down Arrow" })
map({ "n", "i", "v" }, "<Left>", "<Nop>", { desc = "Disable Left Arrow" })
map({ "n", "i", "v" }, "<Right>", "<Nop>", { desc = "Disable Right Arrow" })
