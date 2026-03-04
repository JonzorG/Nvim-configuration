-- ==========================================================
-- ⚙️ CUSTOM COMPILER & CODE EXECUTION
-- ==========================================================
local map = vim.keymap.set

-- Helper function to find a Makefile
local function get_makefile_dir()
	local make_file = vim.fs.find("Makefile", { upward = true, path = vim.fn.expand("%:p:h") })[1]
	if make_file then
		return vim.fn.fnamemodify(make_file, ":h")
	end
	return nil
end

-- ==========================================================
-- <leader>b : BUILD (C/C++ only)
-- ==========================================================
map("n", "<leader>b", function()
	local ext = vim.fn.expand("%:e")
	if ext ~= "c" and ext ~= "cpp" then
		vim.notify("Build step only configured for C/C++ files.", vim.log.levels.INFO)
		return
	end

	vim.cmd("w") -- Save before building
	local project_root = get_makefile_dir()

	if project_root then
		vim.notify("Building via Makefile...", vim.log.levels.INFO)
		-- Change to the Makefile directory, run make, and populate the Quickfix list
		vim.cmd("cd " .. project_root .. " | make")
		vim.cmd("cwindow") -- Automatically open the quickfix window if there are errors
	else
		vim.notify("ERROR: No Makefile found in directory tree!", vim.log.levels.ERROR)
	end
end, { desc = "Compiler: Build via Makefile" })

-- ==========================================================
-- <leader>r : RUN (No Args)
-- ==========================================================
map("n", "<leader>r", function()
	if vim.bo.buftype ~= "" then
		return
	end
	vim.cmd("w")

	local ext = vim.fn.expand("%:e")
	local absolute_path = vim.fn.expand("%:p")

	if ext == "py" then
		vim.cmd("split | term python3 " .. absolute_path)
	elseif ext == "lua" then
		vim.cmd("split | term lua " .. absolute_path)
	elseif ext == "sh" then
		vim.cmd("split | term bash " .. absolute_path)
	elseif ext == "c" or ext == "cpp" then
		vim.ui.input({ prompt = "Executable to run: ", default = "./", completion = "file" }, function(input)
			if input and input ~= "" then
				vim.cmd("split | term " .. input)
			end
		end)
	else
		vim.notify("No run logic defined for file type: " .. ext, vim.log.levels.WARN)
	end
end, { desc = "Compiler: Run Code" })

-- ==========================================================
-- <leader>R : RUN WITH ARGS
-- ==========================================================
map("n", "<leader>R", function()
	if vim.bo.buftype ~= "" then
		return
	end
	vim.cmd("w")

	local ext = vim.fn.expand("%:e")
	local absolute_path = vim.fn.expand("%:p")

	if ext == "py" or ext == "lua" or ext == "sh" then
		local cmd_prefix = (ext == "py" and "python3 ") or (ext == "lua" and "lua ") or "bash "
		vim.ui.input({ prompt = "Arguments: " }, function(args)
			if args then
				vim.cmd("split | term " .. cmd_prefix .. absolute_path .. " " .. args)
			end
		end)
	elseif ext == "c" or ext == "cpp" then
		vim.ui.input({ prompt = "Execute with args: ", default = "./", completion = "file" }, function(input)
			if input and input ~= "" then
				vim.cmd("split | term " .. input)
			end
		end)
	else
		vim.notify("No run logic defined for file type: " .. ext, vim.log.levels.WARN)
	end
end, { desc = "Compiler: Run Code with Arguments" })
