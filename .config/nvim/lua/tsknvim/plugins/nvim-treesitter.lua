return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			highlight = { enable = true },
			indent = { enable = true },
			incremental_selection = { enable = true },
			ensure_installed = {
				"bash",
				"c",
				"cmake",
				"cpp",
				"css",
				"html",
				"lua",
				"markdown",
				"markdown_inline",
				"python",
				"rust",
				"toml"
			},
		},
		config = function(_, opts)
			if vim.fn.has("win32") == 1 then
				require("nvim-treesitter.install").prefer_git = false
			end

			require("nvim-treesitter.configs").setup(opts)
		end,
		build = ":TSUpdate",
		cmd = {
			"TSInstall",
			"TSInstallSync",
			"TSInstallInfo",
			"TSUpdate",
			"TSUpdateSync",
			"TSUninstall",
			"TSBufEnable",
			"TSBufDisable",
			"TSBufToggle",
			"TSEnable",
			"TSDisable",
			"TSToggle",
			"TSModuleInfo",
			"TSEditQuery",
			"TSEditQueryUserAfter",
		},
		ft = {
			"sh",
			"c",
			"cmake",
			"cpp",
			"css",
			"html",
			"lua",
			"markdown",
			"python",
			"rust",
			"toml",
		},
	},
}
