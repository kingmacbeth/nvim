function ColorMyPencils(color)
    color = color or "gruvbox-material"
    vim.o.background = "dark"
    if color == "onedark" then
        require("onedark").setup({ style = "darker" })
        require("onedark").load()
    elseif color == "bamboo" then
        require('bamboo').load()
    else
        vim.cmd.colorscheme(color)
    end
    --vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    --vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
    {
        "folke/tokyonight.nvim",
        version = false,
        lazy = false,
        opts = {},
        priority = 1000, -- make sure to load this before all the other start plugins
        -- Optional; default configuration will be used if setup isn't called.
        config = function()
            ColorMyPencils()
        end
    },
    {
        "sainnhe/gruvbox-material",
        version = false,
        lazy = false,
        priority = 1000,
        config = function()
            ColorMyPencils()
        end
    },
    {
        "rebelot/kanagawa.nvim",
        version = false,
        lazy = false,
        priority = 1000,
        config = function()
            ColorMyPencils()
        end
    },
    {
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            ColorMyPencils('onedark')
        end
    },
    {
        'ribru17/bamboo.nvim',
        lazy = false,
        priority = 1000,
        config = function()
            ColorMyPencils('bamboo')
        end,
    },
    {
        'Biscuit-Theme/nvim',
        as = "biscuit",
        lazy = false,
        priority = 1000,
        config = function()
            ColorMyPencils('biscuit')
        end,
    },
    {
        "wtfox/jellybeans.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            ColorMyPencils('jellybeans')
        end,
    }
}
