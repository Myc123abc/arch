return {
    {
        "akinsho/bufferline.nvim",
        lazy = false,
        priority = 1000,
        version = "*",
        config = function()
require("bufferline").setup {
    options = {
        offsets = {{
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            text_align = "left"
        }}
    }
}
        end
    }
}
