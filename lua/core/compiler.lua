local map = vim.keymap.set

map("n", "<leader>r", function()
	if vim.bo.buftype ~= "" then
		return
	end
	if vim.fn.expand("%:e") ~= "py" then
		vim.notify("Run is only configured for Python (.py) files.", vim.log.levels.WARN)
		return
	end
	vim.cmd("w")
	vim.cmd("split | term python3 " .. vim.fn.shellescape(vim.fn.expand("%:p")))
end, { desc = "Compiler: Run Python File" })

map("n", "<leader>R", function()
	if vim.bo.buftype ~= "" then
		return
	end
	if vim.fn.expand("%:e") ~= "py" then
		vim.notify("Run is only configured for Python (.py) files.", vim.log.levels.WARN)
		return
	end
	vim.cmd("w")
	local file = vim.fn.shellescape(vim.fn.expand("%:p"))
	vim.ui.input({ prompt = "Arguments: " }, function(args)
		if args then
			vim.cmd("split | term python3 " .. file .. " " .. args)
		end
	end)
end, { desc = "Compiler: Run Python File with Args" })
