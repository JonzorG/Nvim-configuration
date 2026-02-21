-- ==========================================
-- INIT.LUA (Entry Point)
-- ==========================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 1. Load Core Settings
require("core.options")
require("core.autocmds")
require("core.keymaps")
require("core.compiler")

-- 2. Bootstrap Lazy (Plugin Manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- 3. Load Plugins
require("lazy").setup("plugins")
