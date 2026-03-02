-- ==========================================================
-- ⚙️ CUSTOM COMPILER & CODE EXECUTION
-- ==========================================================
local map = vim.keymap.set

_G.current_optimization_level = "-O3"

-- Toggle Optimization (-O2 for debugging, -O3 for heavy simulations)
map("n", "<leader>o", function()
	if _G.current_optimization_level == "-O3" then
		_G.current_optimization_level = "-O2"
		print("Switched to DEBUG MODE (-O2)")
	else
		_G.current_optimization_level = "-O3"
		print("Switched to SPEED MODE (-O3)")
	end
end, { desc = "Compiler: Toggle Optimization (-O2/-O3)" })

-- Smart Run: Prioritizes Project Makefiles > Single File Fallback
map("n", "<leader>r", function()
	-- GUARD CLAUSE: Prevent running on menus, dashboards, or empty buffers
	if vim.bo.buftype ~= "" then
		vim.notify("Not a runnable file.", vim.log.levels.WARN)
		return
	end

	local absolute_path = vim.fn.expand("%:p")
	if absolute_path == "" then
		vim.notify("Please save the file first!", vim.log.levels.ERROR)
		return
	end

	vim.cmd("w") -- Always save the current file before running
	local name = vim.fn.expand("%:p:r")
	local ext = vim.fn.expand("%:e")

	-- PRIORITY 1: Smart Project Detection (Makefile)
	-- Searches upwards from the current file's directory to find a Makefile
	local make_file = vim.fs.find("Makefile", { upward = true, path = vim.fn.expand("%:p:h") })[1]
	if make_file then
		local project_root = vim.fn.fnamemodify(make_file, ":h")
		local file_name_no_ext = vim.fn.expand("%:t:r") -- Gets just the file name without extension

		print("Compiling and Running via Makefile...")
		-- Pass the current file name to the 'run' target in the Makefile
		local cmd = "cd " .. project_root .. " && make run FILE=" .. file_name_no_ext

		vim.cmd("split | term " .. cmd)
		return
	end

	-- PRIORITY 2: Universal Single-File Fallbacks
	-- If no Makefile is found, assume this is a standalone script
	if ext == "py" then
		vim.cmd("split | term python3 " .. absolute_path)
	elseif ext == "lua" then
		vim.cmd("split | term lua " .. absolute_path)
	elseif ext == "sh" then
		vim.cmd("split | term bash " .. absolute_path)
	elseif ext == "cpp" or ext == "c" then
		-- Fallback for quick, isolated C/C++ tests outside of a main project folder
		local compiler = (ext == "cpp") and "g++" or "gcc"
		local std = (ext == "cpp") and "-std=c++17" or "-std=c11"
		local flags = _G.current_optimization_level .. " -Wall -Wextra " .. std .. " -lpthread -lrt"
		local cmd = compiler .. " " .. flags .. " " .. absolute_path .. " -o " .. name .. " && " .. name

		print("Compiling isolated single file: " .. compiler)
		vim.cmd("split | term " .. cmd)
	elseif ext == "sql" then
		vim.notify("Use <leader>db to open Dadbod UI, or execute via Python.", vim.log.levels.INFO)
	else
		print("No run logic defined for file type: " .. ext)
	end
end, { desc = "Compiler: Smart Run Code" })
