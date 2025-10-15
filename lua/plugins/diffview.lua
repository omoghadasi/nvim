return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
  keys = {
    { "<leader>gd", "<cmd>DiffviewOpen<cr>",          desc = "Git Diff View" },
    { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File History (current)" },
    { "<leader>gH", "<cmd>DiffviewFileHistory<cr>",   desc = "Project History" },
    { "<leader>gc", "<cmd>DiffviewClose<cr>",         desc = "Close Diffview" },
    { "<leader>gt", "<cmd>DiffviewToggleFiles<cr>",   desc = "Toggle File Panel" },
    { "<leader>gf", "<cmd>DiffviewFocusFiles<cr>",    desc = "Focus File Panel" },
    { "<leader>gr", "<cmd>DiffviewRefresh<cr>",       desc = "Refresh Diffview" },
  },
  config = function()
    local actions = require("diffview.actions")

    require("diffview").setup({
      -- ============ تنظیمات عمومی ============
      diff_binaries = false, -- نمایش diff برای فایل‌های binary
      enhanced_diff_hl = true, -- بهبود syntax highlighting در diff
      git_cmd = { "git" },  -- دستور git
      hg_cmd = { "hg" },    -- دستور mercurial (اگه استفاده می‌کنی)
      use_icons = true,     -- نمایش آیکون‌ها (نیاز به nvim-web-devicons)
      show_help_hints = true, -- نمایش راهنمای کلیدها
      watch_index = true,   -- آپدیت خودکار وقتی git index تغییر می‌کنه

      -- ============ آیکون‌ها ============
      icons = {
        folder_closed = "",
        folder_open = "",
      },
      signs = {
        fold_closed = "",
        fold_open = "",
        done = "✓",
      },

      -- ============ تنظیمات View ============
      view = {
        -- تنظیمات برای diff معمولی (changed files & staged files)
        default = {
          layout = "diff2_horizontal", -- یا: diff2_vertical
          disable_diagnostics = true, -- خاموش کردن LSP diagnostics در diff
          winbar_info = false,    -- نمایش info در winbar
        },
        -- تنظیمات برای merge/rebase conflicts
        merge_tool = {
          layout = "diff3_horizontal", -- BASE | OURS | THEIRS
          -- layout = "diff4_mixed",   -- اگه 4-way می‌خوای
          disable_diagnostics = true,
          winbar_info = true,
        },
        -- تنظیمات برای file history
        file_history = {
          layout = "diff2_horizontal",
          disable_diagnostics = true,
          winbar_info = false,
        },
      },

      -- ============ File Panel ============
      file_panel = {
        listing_style = "tree",       -- "tree" یا "list"
        tree_options = {
          flatten_dirs = true,        -- فولدرهای خالی رو flatten کن
          folder_statuses = "only_folded", -- "never", "only_folded", "always"
        },
        win_config = {
          position = "left", -- "left", "right", "top", "bottom"
          width = 35,
          height = 10,
          win_opts = {
            winhl = "Normal:Normal,FloatBorder:Normal", -- styling
          },
        },
      },

      -- ============ File History Panel ============
      file_history_panel = {
        log_options = {
          git = {
            single_file = {
              diff_merges = "combined",
              -- follow = true, -- دنبال کردن renames
            },
            multi_file = {
              diff_merges = "first-parent",
            },
          },
          hg = {
            single_file = {},
            multi_file = {},
          },
        },
        win_config = {
          position = "bottom",
          height = 16,
          win_opts = {},
        },
      },

      -- ============ Commit Log Panel ============
      commit_log_panel = {
        win_config = {
          height = 16,
        },
      },

      -- ============ Arguments پیش‌فرض ============
      default_args = {
        DiffviewOpen = {},
        DiffviewFileHistory = {},
      },

      -- ============ Hooks ============
      hooks = {
        -- وقتی diff buffer خونده میشه
        diff_buf_read = function(bufnr)
          vim.opt_local.wrap = false
          vim.opt_local.list = false
          vim.opt_local.relativenumber = false
          vim.opt_local.cursorline = true
        end,
        -- وقتی diff buffer وارد میشه
        diff_buf_win_enter = function(bufnr, winid, ctx)
          -- می‌تونی اینجا تنظیمات window-specific بزنی
        end,
        -- وقتی view باز میشه
        view_opened = function(view)
          vim.notify("🔍 Diffview باز شد!", vim.log.levels.INFO)
        end,
        -- وقتی view بسته میشه
        view_closed = function(view)
          vim.notify("✅ Diffview بسته شد", vim.log.levels.INFO)
        end,
        -- قبل از اینکه فایل از panel انتخاب بشه
        view_enter = function(view)
          -- می‌تونی اینجا کارهای اضافی انجام بدی
        end,
      },

      -- ============ Keymaps ============
      keymaps = {
        disable_defaults = false, -- اگه true باشه، باید همه رو خودت تعریف کنی

        -- ============ View Keymaps ============
        view = {
          -- Navigation بین فایل‌ها
          { "n", "<tab>",      actions.select_next_entry,         { desc = "Next file" } },
          { "n", "<s-tab>",    actions.select_prev_entry,         { desc = "Previous file" } },
          { "n", "[F",         actions.select_first_entry,        { desc = "First file" } },
          { "n", "]F",         actions.select_last_entry,         { desc = "Last file" } },

          -- باز کردن فایل
          { "n", "gf",         actions.goto_file_edit,            { desc = "Open file in prev tab" } },
          { "n", "<C-w><C-f>", actions.goto_file_split,           { desc = "Open file in split" } },
          { "n", "<C-w>gf",    actions.goto_file_tab,             { desc = "Open file in new tab" } },

          -- File panel
          { "n", "<leader>e",  actions.focus_files,               { desc = "Focus file panel" } },
          { "n", "<leader>b",  actions.toggle_files,              { desc = "Toggle file panel" } },

          -- Layout
          { "n", "g<C-x>",     actions.cycle_layout,              { desc = "Cycle layout" } },

          -- Merge conflicts
          { "n", "[x",         actions.prev_conflict,             { desc = "Previous conflict" } },
          { "n", "]x",         actions.next_conflict,             { desc = "Next conflict" } },
          { "n", "<leader>co", actions.conflict_choose("ours"),   { desc = "Choose OURS" } },
          { "n", "<leader>ct", actions.conflict_choose("theirs"), { desc = "Choose THEIRS" } },
          { "n", "<leader>cb", actions.conflict_choose("base"),   { desc = "Choose BASE" } },
          { "n", "<leader>ca", actions.conflict_choose("all"),    { desc = "Choose ALL" } },
          { "n", "dx",         actions.conflict_choose("none"),   { desc = "Delete conflict" } },
          {
            "n",
            "<leader>cO",
            actions.conflict_choose_all("ours"),
            { desc = "Choose OURS (all)" },
          },
          {
            "n",
            "<leader>cT",
            actions.conflict_choose_all("theirs"),
            { desc = "Choose THEIRS (all)" },
          },
          {
            "n",
            "<leader>cB",
            actions.conflict_choose_all("base"),
            { desc = "Choose BASE (all)" },
          },
          {
            "n",
            "<leader>cA",
            actions.conflict_choose_all("all"),
            { desc = "Choose ALL (all)" },
          },
          { "n", "dX", actions.conflict_choose_all("none"), { desc = "Delete all conflicts" } },

          -- Custom: بستن سریع با q
          { "n", "q",  "<cmd>DiffviewClose<cr>",            { desc = "Close Diffview" } },
        },

        -- ============ Diff1 Layout ============
        diff1 = {
          { "n", "g?", actions.help({ "view", "diff1" }), { desc = "Open help" } },
        },

        -- ============ Diff2 Layout ============
        diff2 = {
          { "n", "g?", actions.help({ "view", "diff2" }), { desc = "Open help" } },
        },

        -- ============ Diff3 Layout (Merge Tool) ============
        diff3 = {
          { { "n", "x" }, "2do", actions.diffget("ours"),           { desc = "Get from OURS" } },
          { { "n", "x" }, "3do", actions.diffget("theirs"),         { desc = "Get from THEIRS" } },
          { "n",          "g?",  actions.help({ "view", "diff3" }), { desc = "Open help" } },
        },

        -- ============ Diff4 Layout ============
        diff4 = {
          { { "n", "x" }, "1do", actions.diffget("base"),           { desc = "Get from BASE" } },
          { { "n", "x" }, "2do", actions.diffget("ours"),           { desc = "Get from OURS" } },
          { { "n", "x" }, "3do", actions.diffget("theirs"),         { desc = "Get from THEIRS" } },
          { "n",          "g?",  actions.help({ "view", "diff4" }), { desc = "Open help" } },
        },

        -- ============ File Panel Keymaps ============
        file_panel = {
          -- Navigation
          { "n", "j",             actions.next_entry,          { desc = "Next entry" } },
          { "n", "<down>",        actions.next_entry,          { desc = "Next entry" } },
          { "n", "k",             actions.prev_entry,          { desc = "Previous entry" } },
          { "n", "<up>",          actions.prev_entry,          { desc = "Previous entry" } },

          -- باز کردن
          { "n", "<cr>",          actions.select_entry,        { desc = "Open diff" } },
          { "n", "o",             actions.select_entry,        { desc = "Open diff" } },
          { "n", "l",             actions.select_entry,        { desc = "Open diff" } },
          { "n", "<2-LeftMouse>", actions.select_entry,        { desc = "Open diff" } },

          -- Staging
          { "n", "-",             actions.toggle_stage_entry,  { desc = "Stage/unstage" } },
          { "n", "s",             actions.toggle_stage_entry,  { desc = "Stage/unstage" } },
          { "n", "S",             actions.stage_all,           { desc = "Stage all" } },
          { "n", "U",             actions.unstage_all,         { desc = "Unstage all" } },
          { "n", "X",             actions.restore_entry,       { desc = "Restore entry" } },

          -- Commit log
          { "n", "L",             actions.open_commit_log,     { desc = "Open commit log" } },

          -- Folding
          { "n", "zo",            actions.open_fold,           { desc = "Open fold" } },
          { "n", "h",             actions.close_fold,          { desc = "Close fold" } },
          { "n", "zc",            actions.close_fold,          { desc = "Close fold" } },
          { "n", "za",            actions.toggle_fold,         { desc = "Toggle fold" } },
          { "n", "zR",            actions.open_all_folds,      { desc = "Open all folds" } },
          { "n", "zM",            actions.close_all_folds,     { desc = "Close all folds" } },

          -- Scroll
          { "n", "<c-b>",         actions.scroll_view(-0.25),  { desc = "Scroll up" } },
          { "n", "<c-f>",         actions.scroll_view(0.25),   { desc = "Scroll down" } },

          -- Navigation بین فایل‌ها
          { "n", "<tab>",         actions.select_next_entry,   { desc = "Next file" } },
          { "n", "<s-tab>",       actions.select_prev_entry,   { desc = "Previous file" } },
          { "n", "[F",            actions.select_first_entry,  { desc = "First file" } },
          { "n", "]F",            actions.select_last_entry,   { desc = "Last file" } },

          -- باز کردن فایل
          { "n", "gf",            actions.goto_file_edit,      { desc = "Open in prev tab" } },
          { "n", "<C-w><C-f>",    actions.goto_file_split,     { desc = "Open in split" } },
          { "n", "<C-w>gf",       actions.goto_file_tab,       { desc = "Open in new tab" } },

          -- View options
          { "n", "i",             actions.listing_style,       { desc = "Toggle list/tree" } },
          { "n", "f",             actions.toggle_flatten_dirs, { desc = "Toggle flatten dirs" } },
          { "n", "R",             actions.refresh_files,       { desc = "Refresh" } },

          -- Panel
          { "n", "<leader>e",     actions.focus_files,         { desc = "Focus file panel" } },
          { "n", "<leader>b",     actions.toggle_files,        { desc = "Toggle file panel" } },

          -- Layout
          { "n", "g<C-x>",        actions.cycle_layout,        { desc = "Cycle layout" } },

          -- Conflicts
          { "n", "[x",            actions.prev_conflict,       { desc = "Previous conflict" } },
          { "n", "]x",            actions.next_conflict,       { desc = "Next conflict" } },

          -- Help
          { "n", "g?",            actions.help("file_panel"),  { desc = "Help" } },

          -- Custom
          { "n", "q",             "<cmd>DiffviewClose<cr>",    { desc = "Close" } },
        },

        -- ============ File History Panel ============
        file_history_panel = {
          -- Options
          { "n", "g!",            actions.options,                    { desc = "Options" } },
          { "n", "<C-A-d>",       actions.open_in_diffview,           { desc = "Open in diffview" } },
          { "n", "y",             actions.copy_hash,                  { desc = "Copy commit hash" } },
          { "n", "L",             actions.open_commit_log,            { desc = "Commit details" } },
          { "n", "X",             actions.restore_entry,              { desc = "Restore file" } },

          -- Folding
          { "n", "zo",            actions.open_fold,                  { desc = "Open fold" } },
          { "n", "zc",            actions.close_fold,                 { desc = "Close fold" } },
          { "n", "h",             actions.close_fold,                 { desc = "Close fold" } },
          { "n", "za",            actions.toggle_fold,                { desc = "Toggle fold" } },
          { "n", "zR",            actions.open_all_folds,             { desc = "Open all folds" } },
          { "n", "zM",            actions.close_all_folds,            { desc = "Close all folds" } },

          -- Navigation
          { "n", "j",             actions.next_entry,                 { desc = "Next entry" } },
          { "n", "<down>",        actions.next_entry,                 { desc = "Next entry" } },
          { "n", "k",             actions.prev_entry,                 { desc = "Previous entry" } },
          { "n", "<up>",          actions.prev_entry,                 { desc = "Previous entry" } },

          -- باز کردن
          { "n", "<cr>",          actions.select_entry,               { desc = "Open diff" } },
          { "n", "o",             actions.select_entry,               { desc = "Open diff" } },
          { "n", "l",             actions.select_entry,               { desc = "Open diff" } },
          { "n", "<2-LeftMouse>", actions.select_entry,               { desc = "Open diff" } },

          -- Scroll
          { "n", "<c-b>",         actions.scroll_view(-0.25),         { desc = "Scroll up" } },
          { "n", "<c-f>",         actions.scroll_view(0.25),          { desc = "Scroll down" } },

          -- Navigation بین فایل‌ها
          { "n", "<tab>",         actions.select_next_entry,          { desc = "Next file" } },
          { "n", "<s-tab>",       actions.select_prev_entry,          { desc = "Previous file" } },
          { "n", "[F",            actions.select_first_entry,         { desc = "First file" } },
          { "n", "]F",            actions.select_last_entry,          { desc = "Last file" } },

          -- باز کردن فایل
          { "n", "gf",            actions.goto_file_edit,             { desc = "Open in prev tab" } },
          { "n", "<C-w><C-f>",    actions.goto_file_split,            { desc = "Open in split" } },
          { "n", "<C-w>gf",       actions.goto_file_tab,              { desc = "Open in new tab" } },

          -- Panel
          { "n", "<leader>e",     actions.focus_files,                { desc = "Focus file panel" } },
          { "n", "<leader>b",     actions.toggle_files,               { desc = "Toggle file panel" } },

          -- Layout
          { "n", "g<C-x>",        actions.cycle_layout,               { desc = "Cycle layout" } },

          -- Help
          { "n", "g?",            actions.help("file_history_panel"), { desc = "Help" } },

          -- Custom
          { "n", "q",             "<cmd>DiffviewClose<cr>",           { desc = "Close" } },
        },

        -- ============ Option Panel ============
        option_panel = {
          { "n", "<tab>", actions.select_entry,         { desc = "Select option" } },
          { "n", "q",     actions.close,                { desc = "Close" } },
          { "n", "g?",    actions.help("option_panel"), { desc = "Help" } },
        },

        -- ============ Help Panel ============
        help_panel = {
          { "n", "q",     actions.close, { desc = "Close help" } },
          { "n", "<esc>", actions.close, { desc = "Close help" } },
        },
      },
    })

    -- ============ Integration با which-key ============
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.add({
        { "<leader>g", group = "󰊢 Git/Diffview", icon = "󰊢" },
      })
    end

    -- ============ تنظیمات بصری ============
    -- خطوط مورب برای deleted lines
    vim.opt.fillchars:append({ diff = "╱" })

    -- ============ Autocmd برای تنظیمات اضافی ============
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "DiffviewFiles",
      callback = function()
        vim.opt_local.cursorline = true
        vim.opt_local.wrap = false
      end,
    })
  end,
}
