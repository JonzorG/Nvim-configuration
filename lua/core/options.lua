vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.scrolloff = 0

vim.opt.pumheight = 10

vim.diagnostic.config({
	virtual_text = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = "󰌵 ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
	update_in_insert = false,
	underline = true,
	severity_sort = true,
	float = { border = "rounded" },
})

-- ==========================================
-- PROVIDER OPTIMIZATIONS
-- ==========================================
-- Disable unused providers to avoid overhead and healthcheck warnings
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0

-- Explicitly set python3 host to bypass runtime search
vim.g.python3_host_prog = "/usr/bin/python3"
