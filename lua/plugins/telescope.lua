return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-live-grep-args.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            "nvim-telescope/telescope-project.nvim",
        },
        config = function()
            local builtin = require("telescope.builtin")
            local project_actions = require("telescope._extensions.project.actions")
            local lga_actions = require("telescope-live-grep-args.actions")
            require("telescope").setup({
                extensions = {
                    live_grep_args = {
                        mappings = { -- extend mappings
                            i = {
                                ["<C-k>"] = lga_actions.quote_prompt(),
                                ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                            },
                        },
                    },
                    project = {
                        hidden_files = true, -- default: false
                        theme = "dropdown",
                        order_by = "recent",
                        search_by = "title",
                        sync_with_nvim_tree = true, -- default false
                        -- default for on_project_selected = find project files
                        on_project_selected = function(prompt_bufnr)
                            project_actions.change_working_directory(prompt_bufnr, false)
                        end,
                    },
                },
            })
            require("telescope").load_extension("live_grep_args")
            require("telescope").load_extension("file_browser")
            require("telescope").load_extension("project")
            vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
            vim.keymap.set("n", "<leader>fb", builtin.buffers, {})
            vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
            vim.keymap.set(
                "n",
                "<leader>fg",
                ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>"
            )
            vim.keymap.set("n", "<leader>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>")
            vim.keymap.set("n", "<leader>fp", ":lua require'telescope'.extensions.project.project{}<CR>")
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            require("telescope").setup({
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown({}),
                    },
                },
            })
            require("telescope").load_extension("ui-select")
        end,
    },
}
