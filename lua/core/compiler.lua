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
		vim.cmd("silent make -C " .. vim.fn.fnameescape(project_root))

		local qf_list = vim.fn.getqflist()
		local has_errors = false
		local build_output = {}

		for _, item in ipairs(qf_list) do
			if item.valid == 1 then
				has_errors = true
			elseif item.text and item.text:match("%S") then
				if not item.text:match("make%[%d+%]:") then
					table.insert(build_output, item.text)
				end
			end
		end

		local has_trouble, trouble = pcall(require, "trouble")
		if has_errors then
			vim.notify("Build failed! Check Trouble/Quickfix.", vim.log.levels.ERROR)
			if has_trouble then
				trouble.open("qflist")
			else
				vim.cmd("cwindow")
			end
		else
			-- Join the make output lines together
			local out_str = table.concat(build_output, "\n")
			if out_str == "" then
				out_str = "Nothing to be done for 'all'."
			end

			vim.notify("" .. out_str .. "", vim.log.levels.INFO)

			if has_trouble then
				pcall(trouble.close, "qflist")
			end
			vim.cmd("cclose")
		end
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
