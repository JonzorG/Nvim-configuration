-- [FILE START: ./lua/core/compiler.lua] --
-- ==========================================================
-- ⚙️ CUSTOM COMPILER & CODE EXECUTION
-- ==========================================================
local map = vim.keymap.set

_G.current_optimization_level = "-O2"
_G.compiler_debug_mode = false

-- Toggle Debug Compilation (-g -O0)
map("n", "<leader>cd", function()
	_G.compiler_debug_mode = not _G.compiler_debug_mode
	local status = _G.compiler_debug_mode and "ON (-g -O0)" or "OFF (" .. _G.current_optimization_level .. ")"
	print("Debug Compilation: " .. status)
end, { desc = "Compiler: Toggle Debug Mode (-g -O0)" })

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
	local make_file = vim.fs.find("Makefile", { upward = true, path = vim.fn.expand("%:p:h") })[1]
	if make_file then
		local project_root = vim.fn.fnamemodify(make_file, ":h")
		local file_name_no_ext = vim.fn.expand("%:t:r")

		print("Compiling and Running via Makefile...")
		local cmd = "cd " .. project_root .. " && make run FILE=" .. file_name_no_ext
		vim.cmd("split | term " .. cmd)
		return
	end

	-- PRIORITY 2: Universal Single-File Fallbacks
	if ext == "py" then
		vim.cmd("split | term python3 " .. absolute_path)
	elseif ext == "lua" then
		vim.cmd("split | term lua " .. absolute_path)
	elseif ext == "sh" then
		vim.cmd("split | term bash " .. absolute_path)
	elseif ext == "cpp" or ext == "c" then
		local compiler = (ext == "cpp") and "g++" or "gcc"
		local std = (ext == "cpp") and "-std=c++17" or "-std=c11"

		-- Inject debug flags if debug mode is active
		local opt_flags = _G.compiler_debug_mode and "-g -O0" or _G.current_optimization_level
		local flags = opt_flags .. " -Wall -Wextra " .. std .. " -lpthread -lrt"

		local cmd = compiler .. " " .. flags .. " " .. absolute_path .. " -o " .. name .. " && " .. name

		print("Compiling isolated single file: " .. compiler .. " " .. opt_flags)
		vim.cmd("split | term " .. cmd)
	elseif ext == "sql" then
		vim.notify("Use <leader>db to open Dadbod UI, or execute via Python.", vim.log.levels.INFO)
	else
		print("No run logic defined for file type: " .. ext)
	end
end, { desc = "Compiler: Smart Run Code" })
