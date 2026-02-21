-- ==========================================================
-- ⚙️ CUSTOM COMPILER & CODE EXECUTION
-- ==========================================================
local map = vim.keymap.set

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
end, { desc = "Compiler: Toggle Optimization (-O2/-O3)" })

-- Smart Run: Compiles generic projects or runs scripts
map("n", "<leader>r", function()
	-- GUARD CLAUSE 1: Prevent running on menus, dashboards, or Oil buffers
	if vim.bo.buftype ~= "" then
		vim.notify("Not a runnable file.", vim.log.levels.WARN)
		return
	end

	-- GUARD CLAUSE 2: Prevent running on completely empty/unsaved new files
	if vim.fn.expand("%") == "" then
		vim.notify("Please save the file first!", vim.log.levels.ERROR)
		return
	end

	vim.cmd("w") -- Save file first
	local file = vim.fn.expand("%")
	local name = vim.fn.expand("%:r")
	local ext = vim.fn.expand("%:e")

	if ext == "py" then
		vim.cmd("split | term python3 " .. file)
	elseif ext == "c" or ext == "cpp" then
		local cmd = ""
		if vim.fn.filereadable("Makefile") == 1 then
			cmd = "make && ./main"
		else
			local compiler = (ext == "cpp") and "g++" or "gcc"
			local src_files = (ext == "cpp") and "*.cpp" or "*.c"
			local flags = _G.current_optimization_level .. " -Wall -Wextra"
			local libs = "-lm"

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
				end
			end
			cmd = compiler .. " " .. flags .. " " .. src_files .. " -o " .. name .. " " .. libs .. " && ./" .. name
		end
		print("Running: " .. cmd)
		vim.cmd("split | term " .. cmd)
	else
		print("Unknown file type: " .. ext)
	end
end, { desc = "Compiler: Run Code (Smart Detect)" })
