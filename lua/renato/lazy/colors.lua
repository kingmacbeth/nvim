function ColorMyPencils(color)
	color = color or "gruvbox-material"
	vim.cmd.colorscheme(color)
	vim.o.background = "dark"

	--vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	--vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {

--	{
--		"folke/tokyonight.nvim",
--		lazy = false,
--		opts = {},
--		config = function()
--			ColorMyPencils()
--		end
--	},

--	{
--		"neanias/everforest-nvim",
--		version = false,
--		lazy = false,
--		priority = 1000, -- make sure to load this before all the other start plugins
--		-- Optional; default configuration will be used if setup isn't called.
--		config = function()
--			ColorMyPencils()
--		end
--	},

	{
		"sainnhe/gruvbox-material",
		version = false,
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		-- Optional; default configuration will be used if setup isn't called.
		config = function()
			ColorMyPencils()
		end
	},

	{
		"rebelot/kanagawa.nvim",
		version = false,
		lazy = false,
		priority = 1000, -- make sure to load this before all the other start plugins
		-- Optional; default configuration will be used if setup isn't called.
		config = function()
			ColorMyPencils()
		end
	},


}
