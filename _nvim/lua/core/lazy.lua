-----------------------------------------------------------
-- Plugin manager configuration file
-----------------------------------------------------------

-- Plugin manager: lazy.nvim
-- URL: https://github.com/folke/lazy.nvim

-- For information about installed plugins see the README:
-- neovim-lua/README.md
-- https://github.com/brainfucksec/neovim-lua#readme

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end

-- Start setup
lazy.setup({
	spec = {
		-- Colorscheme:
		-- The colorscheme should be available when starting Neovim.
		{
			"navarasu/onedark.nvim",
			lazy = false, -- make sure we load this during startup if it is your main colorscheme
			priority = 1000, -- make sure to load this before all the other start plugins
		},

		-- other colorschemes:
		{ "ellisonleao/gruvbox.nvim", priority = 1000, config = true },
		{ "tanvirtin/monokai.nvim", lazy = true },
		{ "https://github.com/rose-pine/neovim", name = "rose-pine", lazy = true },

		-- fuzzy search
		{
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
		},

		{
			"folke/which-key.nvim",
			event = "VeryLazy",
			init = function()
				vim.o.timeout = true
				vim.o.timeoutlen = 300
			end,
			opts = {
				-- your configuration comes here
				-- or leave it empty to use the default settings
				-- refer to the configuration section below
			},
		},

		-- Icons
		{ "nvim-tree/nvim-web-devicons", lazy = true },

		-- Dashboard (start screen)
		{
			"goolord/alpha-nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},

		-- Git labels
		{
			"lewis6991/gitsigns.nvim",
			lazy = true,
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons",
			},
			opts = {
				current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
			},
		},

		-- File explorer
		{
			"nvim-tree/nvim-tree.lua",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},

		-- Statusline
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
		},

		-- Treesitter
		{ "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

		-- Aerial
		{
			"stevearc/aerial.nvim",
			opts = {},
			-- Optional dependencies
			dependencies = {
				"nvim-treesitter/nvim-treesitter",
				"nvim-tree/nvim-web-devicons",
			},
		},

		-- Indent line
		{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

		-- Tag viewer
		{ "preservim/tagbar" },

		-- Autopair
		{
			"windwp/nvim-autopairs",
			event = "InsertEnter",
			opts = {},
		},

		-- LSP
		{ "neovim/nvim-lspconfig" },

		-- Formatter
		{ "stevearc/conform.nvim", opts = {} },

		-- Autocomplete
		{
			"hrsh7th/nvim-cmp",
			-- load cmp on InsertEnter
			event = "InsertEnter",
			-- these dependencies will only be loaded when cmp loads
			-- dependencies are always lazy-loaded unless specified otherwise
			dependencies = {
				"L3MON4D3/LuaSnip",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-buffer",
				"saadparwaiz1/cmp_luasnip",
			},
		},

		-- add this to your lua/plugins.lua, lua/plugins/init.lua,  or the file you keep your other plugins:
		{
			"numToStr/Comment.nvim",
			lazy = false,
			opts = {},
		},

		-- highlight current window
		-- {
		-- 	"levouh/tint.nvim",
		-- 	lazy = false,
		-- 	opts = {},
		-- },
	},
})
