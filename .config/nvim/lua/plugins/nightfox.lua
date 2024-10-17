return {
	{ -- You can easily change to a different colorscheme.
		-- Change the name of the colorscheme plugin below, and then
		-- change the command in the config to whatever the name of that colorscheme is.
		--
		-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
		"EdenEast/nightfox.nvim",
		priority = 1000,
		lazy = false,
		config = function()
			require("nightfox").setup({
				-- Options
			})
			require("nightfox").load()
			-- You can configure highlights by doing something like:
			vim.cmd.hi("Comment gui=none")
		end,
	},
}
-- vim: ts=2 sts=2 sw=2 et
