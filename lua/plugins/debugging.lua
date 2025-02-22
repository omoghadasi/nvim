return {
    "mfussenegger/nvim-dap",
    dependencies = { "jay-babu/mason-nvim-dap.nvim", "nvim-neotest/nvim-nio", "rcarriga/nvim-dap-ui", "mfussenegger/nvim-dap-python" },
    config = function()
        require("mason-nvim-dap").setup({
            ensure_installed = { "python" }, -- زبان‌های مورد نظر
        })
        local dap, dapui = require("dap"), require("dapui")

        vim.keymap.set("n", "<F5>", dap.continue, { desc = "Start/Continue debugging" })
        vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Step Over" })
        vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Step Into" })
        vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Step Out" })
        vim.keymap.set("n", "<Leader>B", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
        vim.keymap.set({ 'n', 'v' }, '<Leader>dh', function()
            require('dap.ui.widgets').hover()
        end)
        vim.keymap.set('n', '<Leader>df', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.frames)
        end)
        vim.keymap.set('n', '<Leader>ds', function()
            local widgets = require('dap.ui.widgets')
            widgets.centered_float(widgets.scopes)
        end)

        dap.adapters.python = {
            type = "executable",
            command = "/home/omid/project/markazeahan-odoo/venv/bin/python", -- مسیر پایتون محیط مجازی شما
            args = { "-m", "debugpy.adapter" },
        }

        dap.configurations.python = {
            {
                type = "python",
                request = "launch",
                name = "Launch Odoo",
                program = "${workspaceFolder}/odoo-bin",   -- مسیر odoo-bin
                args = { "-c", "odoo.conf", "--dev=all" }, -- آرگومان‌ها
                cwd = "${workspaceFolder}",                -- دایرکتوری کاری
                console = "integratedTerminal",            -- ترمینال اجرا
                justMyCode = true,                         -- برای محدود کردن دیباگ به کد شما
            },
        }
        dapui.setup()
        vim.keymap.set("n", "<Leader>du", require("dapui").toggle, { desc = "Toggle Debug UI" })

        require("dap-python").setup()
        dap.listeners.before.attach.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.launch.dapui_config = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated.dapui_config = function()
            dapui.close()
        end
        dap.listeners.before.event_exited.dapui_config = function()
            dapui.close()
        end
    end,
}
