return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree",
  keys = {
    {
      "<C-e>",
      ":Neotree reveal toggle float<cr>",
      desc = "Toggle Neo-tree (Float)",
    },
  },
  config = function()
    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
        },
      },
    })

    require("neo-tree").setup({
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      open_files_do_not_replace_types = { "terminal", "trouble", "qf" },
      sort_case_insensitive = false,
      -- ============ Default Component Configs ============
      default_component_configs = {
        icon = {
          default = "󰈙",
          highlight = "NeoTreeFileIcon",
        },
        modified = {
          symbol = "●",
          highlight = "NeoTreeModified",
        },
        name = {
          trailing_slash = false,
          use_git_status_colors = true,
          highlight = "NeoTreeFileName",
        },
        git_status = {
          symbols = {
            added = "✚",
            deleted = "✖",
            modified = "",
            renamed = "󰁕",
            untracked = "",
            ignored = "",
            unstaged = "󰄱",
            staged = "",
            conflict = "",
          },
        },
        file_size = {
          enabled = true,
          required_width = 34,
        },
        type = {
          enabled = true,
          required_width = 122,
        },
        last_modified = {
          enabled = true,
          required_width = 88,
        },
        created = {
          enabled = true,
          required_width = 110,
        },
        symlink_target = {
          enabled = false,
        },
      },

      -- ============ Commands (اختیاری) ============
      commands = {
        -- Custom command برای کپی path
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local results = {
            filepath,
            modify(filepath, ":."),
            modify(filepath, ":~"),
            filename,
            modify(filename, ":r"),
            modify(filename, ":e"),
          }

          vim.ui.select({
            "1. Absolute path: " .. results[1],
            "2. Path relative to CWD: " .. results[2],
            "3. Path relative to HOME: " .. results[3],
            "4. Filename: " .. results[4],
            "5. Filename without extension: " .. results[5],
            "6. Extension of the filename: " .. results[6],
          }, { prompt = "Choose to copy to clipboard:" }, function(choice)
            if choice then
              local i = tonumber(choice:sub(1, 1))
              if i then
                local result = results[i]
                vim.fn.setreg("+", result)
                vim.notify("Copied: " .. result)
              end
            end
          end)
        end,
      },

      -- ============ Window (Float Mode) ============
      window = {
        position = "float",
        width = 60, -- عرض float window
        popup = {
          size = {
            height = "90%",
            width = "60%",
          },
          position = "50%",
        },
        mapping_options = {
          noremap = true,
          nowait = true,
        },
      },

      -- ============ Filesystem ============
      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        hijack_netrw = true,
        hijack_netrw_behavior = "open_default",
        use_libuv_file_watcher = true, -- auto-refresh
      },

      source_selector = {
        winbar = true,
        statusline = true,
      },
    })

    -- ============ Custom Highlights ============
    vim.api.nvim_set_hl(0, "NeoTreeFloatBorder", { fg = "#7aa2f7", bg = "none" })
    vim.api.nvim_set_hl(0, "NeoTreeFloatTitle", { fg = "#7aa2f7", bg = "none", bold = true })

    -- Git status colors
    vim.api.nvim_set_hl(0, "NeoTreeGitAdded", { fg = "#9ece6a" })
    vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = "#e0af68" })
    vim.api.nvim_set_hl(0, "NeoTreeGitDeleted", { fg = "#f7768e" })
    vim.api.nvim_set_hl(0, "NeoTreeGitConflict", { fg = "#bb9af7" })
    vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { fg = "#73daca" })
    vim.api.nvim_set_hl(0, "NeoTreeGitIgnored", { fg = "#545c7e" })
    vim.api.nvim_set_hl(0, "NeoTreeGitUnstaged", { fg = "#db4b4b" })
    vim.api.nvim_set_hl(0, "NeoTreeGitStaged", { fg = "#9ece6a" })

    -- File/Folder icons
    vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#7aa2f7" })
    vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#7aa2f7" })
    vim.api.nvim_set_hl(0, "NeoTreeFileIcon", { fg = "#c0caf5" })
    vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = "#c0caf5" })
    vim.api.nvim_set_hl(0, "NeoTreeModified", { fg = "#e0af68" })
    vim.api.nvim_set_hl(0, "NeoTreeIndentMarker", { fg = "#3b4261" })
    vim.api.nvim_set_hl(0, "NeoTreeExpander", { fg = "#7aa2f7" })

    -- ============ Integration با which-key ============
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.add({
        { "<C-e>", desc = "󰙅 Toggle Explorer (Float)" },
      })
    end
  end,
}
