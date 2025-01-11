return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ts_ls",
                    "bashls",
                    "cssls",
                    "html",
                    "jsonls",
                    "intelephense",
                    "pyright",
                    "sqlls",
                    "tailwindcss",
                    "lemminx",
                },
                automatic_setup = true,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup({ capabilities = capabilities, })
            lspconfig.pyright.setup({
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            autoSearchPaths = true,                                 -- به طور خودکار مسیرها را جستجو می‌کند
                            useLibraryCodeForTypes = true,                          -- برای استفاده از کد کتابخانه‌ها
                            diagnosticMode = 'workspace',                           -- خطاها را در سطح workspace بررسی می‌کند
                            typeCheckingMode = 'basic',                             -- سطح بررسی نوع پایه
                        }
                    }
                }
            })
            lspconfig.ts_ls.setup({ capabilities = capabilities, })
            lspconfig.intelephense.setup({ capabilities = capabilities, })
            lspconfig.html.setup({ capabilities = capabilities, })
            lspconfig.cssls.setup({ capabilities = capabilities })
            lspconfig.bashls.setup({ capabilities = capabilities })
            lspconfig.jsonls.setup({ capabilities = capabilities })
            lspconfig.sqlls.setup({ capabilities = capabilities })
            lspconfig.tailwindcss.setup({ capabilities = capabilities })
            lspconfig.lemminx.setup({ capabilities = capabilities })
            vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
        end,
    },
}
