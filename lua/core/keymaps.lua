local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- ==========================================
-- [ GENERAL ] BASIC EDITOR COMMANDS
-- ==========================================

-- Window Navigation
map("n", "<C-j>", "<C-e>", { desc = "Scroll window down" })
map("n", "<C-k>", "<C-y>", { desc = "Scroll window up" })

-- Move Lines (Alt + j/k)
map("n", "<A-j>", ":m .+1<CR>==", opts)
map("n", "<A-k>", ":m .-2<CR>==", opts)
map("i", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
map("i", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)
map("v", "<A-j>", ":m '>+1<CR>gv=gv", opts)
map("v", "<A-k>", ":m '<-2<CR>gv=gv", opts)

-- Spell Check
-- Toggle Spell Check with feedback
map("n", "<leader>sc", function()
	vim.wo.spell = not vim.wo.spell
	vim.notify("Spell Check: " .. (vim.wo.spell and "On" or "Off"))
end, { desc = "Toggle Spell Check" })

-- Yank to system clipboard
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Yank to System Clipboard" })

-- ==========================================
-- [ DIAGNOSTICS ] ERRORS & WARNINGS (Restored)
-- ==========================================
-- Open floating message for the error on current line
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show Line Diagnostics" })

-- ==========================================
-- [ TELESCOPE ] SEARCH & FIND
-- ==========================================
local function tel(builtin)
	return function()
		require("telescope.builtin")[builtin]()
	end
end

map("n", "<leader>ff", tel("find_files"), { desc = "Find Files (Root)" })
map("n", "<leader>fg", tel("live_grep"), { desc = "Search Text (Grep)" })
map("n", "<leader>fb", tel("buffers"), { desc = "Find Open Buffers" })
-- [ TELESCOPE ] EXTRA TOOLS
map("n", "z=", function()
	require("telescope.builtin").spell_suggest(require("telescope.themes").get_cursor({
		initial_mode = "normal",
	}))
end, { desc = "Spell Suggestions (Cursor Popup)" })
map("n", "<leader>sr", function()
	require("telescope.builtin").registers({ initial_mode = "normal" })
end, { desc = "Search Registers" })
map("n", "<leader>ss", tel("lsp_document_symbols"), { desc = "Find Symbols (LSP)" })
map("n", "<leader>sd", function()
	require("telescope.builtin").diagnostics({ initial_mode = "normal" })
end, { desc = "Search Diagnostics" })
map("n", "<leader>sk", tel("keymaps"), { desc = "Search Keymaps" })

vim.keymap.set(
	"n",
	"<F2>",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "Rename symbol in current file" }
)
-- Custom: Search inside .config folder
map("n", "<leader>fc", function()
	require("telescope.builtin").find_files({ cwd = os.getenv("HOME") .. "/.config/nvim" })
end, { desc = "Search Config Nvim Files" })

-- Custom: Search from Documents (~/Documents)
map("n", "<leader>fr", function()
	require("telescope.builtin").find_files({ cwd = os.getenv("HOME") .. "/Documents" })
end, { desc = "Search Home Directory" })

-- ==========================================
-- [ COMPILER ] RUN CODE & OPTIMIZATION
-- ==========================================
_G.current_optimization_level = "-O3"

-- Toggle Optimization
map("n", "<leader>o", function()
	if _G.current_optimization_level == "-O3" then
		_G.current_optimization_level = "-O2"
		print("Switched to SCHOOL MODE (-O2)")
	else
		_G.current_optimization_level = "-O3"
		print("Switched to SPEED MODE (-O3)")
	end
end, { desc = "Toggle Optimization (-O2/-O3)" })

-- Smart Run: Compiles generic projects or runs scripts
vim.keymap.set("n", "<leader>r", function()
	vim.cmd("w") -- Save file first
	local file = vim.fn.expand("%")
	local name = vim.fn.expand("%:r") -- filename without extension
	local ext = vim.fn.expand("%:e")

	-- 1. PYTHON
	if ext == "py" then
		vim.cmd("split | term python3 " .. file)

	-- 2. C / C++ (Updated for Whole Folder)
	elseif ext == "c" or ext == "cpp" then
		local cmd = ""

		-- Check for a Makefile first (Best Practice)
		if vim.fn.filereadable("Makefile") == 1 then
			cmd = "make && ./main" -- Assuming your makefile outputs 'main'
		else
			-- No Makefile? Compile EVERYTHING (*.cpp) manually
			local compiler = (ext == "cpp") and "g++" or "gcc"
			local src_files = (ext == "cpp") and "*.cpp" or "*.c"
			local flags = _G.current_optimization_level .. " -Wall -Wextra"
			local libs = "-lm"

			-- Auto-detect libraries based on your current file's includes
			local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
			for _, line in ipairs(lines) do
				if line:match("gmp.h") then
					libs = libs .. " -lgmp"
				end
				if line:match("pthread.h") or line:match("omp.h") then
					libs = libs .. " -pthread -fopenmp"
				end
				if line:match("ncurses.h") then
					libs = libs .. " -lncurses"
				end
				if line:match("openssl") then
					libs = libs .. " -lssl -lcrypto"
				end
				if line:match("GL/glut.h") then
					libs = libs .. " -lglut -lGL -lGLU"
				end -- Added OpenGL support
			end

			-- The Command: Compiler + Flags + ALL FILES + Output + Libraries + Run
			cmd = compiler .. " " .. flags .. " " .. src_files .. " -o " .. name .. " " .. libs .. " && ./" .. name
		end

		print("Running: " .. cmd)
		vim.cmd("split | term " .. cmd)
	else
		print("Unknown file type: " .. ext)
	end
end, { desc = "Run Code (Smart Detect)" })
