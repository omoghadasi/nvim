return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup({
            styles = {       -- Handles the styles of general hi groups (see `:h highlight-args`):
                comments = { "italic" }, -- Change the style of comments
                conditionals = { "italic", "bold" },
                loops = { "bold" },
                functions = { "bold" },
                keywords = { "bold" },
                strings = { "bold" },
                variables = { "bold" },
                numbers = { "bold" },
                booleans = { "bold" },
                properties = { "bold" },
                types = { "bold" },
                operators = { "bold" },
                -- miscs = {}, -- Uncomment to turn off hard-coded styles
            },
            integrations = {
                barbar = true,
                mason = true,
                diffview = true,
                neotree = true,
                which_key = true,
            },
            color_overrides = {
                all = {
                    base = "#242837",
                    mantle = "#292d3e",
                    crust = "#292d3e",
                    yellow = "#ffcb6b",
                    red = "#ff5572",
                    green = "#62de84",
                    blue = "#60baec",
                    pink = "#f580ff",
                    mauve = "#f580ff",
                    sky = "#60baec",
                    maroon = "#ff5572",
                },
            },
            highlight_overrides = {
                all = function(colors)
                    return {
                        ["@variable"] = {
                            fg = colors.yellow,
                        },
                        ["@property"] = {
                            fg = colors.red,
                        },
                        ["@variable.parameter"] = {
                            fg = colors.red,
                        },
                        ["@variable.member"] = {
                            fg = colors.red,
                        },
                        ["@keyword.export"] = {
                            fg = colors.mauve,
                        },
                        ["@lsp.type.interface"] = {
                            fg = colors.yellow,
                        },
                        -- تنظیمات مربوط به Neo-tree
                        NeoTreeCursorLine = { bg = colors.surface1 }, -- پس‌زمینه آیتم انتخابی
                        NeoTreeNormal = { bg = colors.mantle }, -- پس‌زمینه کلی
                        NeoTreeNormalNC = { bg = colors.mantle }, -- پس‌زمینه در حالت غیرفعال
                    }
                end,
            },
        })
        vim.cmd.colorscheme("catppuccin-mocha")
    end,
}
