return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    -- ============ تنظیمات اصلی ============
    labels = "asdfghjklqwertyuiopzxcvbnm",
    search = {
      -- جستجو به محض تایپ
      multi_window = true, -- جستجو در تمام پنجره‌ها
      forward = true,   -- جهت جستجو
      wrap = true,      -- wrap around در انتهای فایل
      mode = "exact",   -- "exact", "search", "fuzzy"
      incremental = false, -- جستجوی incremental
      exclude = {
        "notify",
        "cmp_menu",
        "noice",
        "flash_prompt",
        function(win)
          -- exclude non-focusable windows
          return not vim.api.nvim_win_get_config(win).focusable
        end,
      },
      trigger = "",    -- کاراکتر trigger (خالی = هیچی)
      max_length = false, -- حداکثر طول pattern
    },

    -- ============ Jump تنظیمات ============
    jump = {
      jumplist = true, -- اضافه کردن به jumplist
      pos = "start",   -- "start", "end", "range"
      offset = nil,    -- offset برای jump
      nohlsearch = false, -- غیرفعال کردن hlsearch بعد از jump
      autojump = false, -- jump خودکار اگه فقط یه match بود
      inclusive = nil, -- nil استفاده از مقدار vim
      register = false, -- ذخیره position در register
    },

    -- ============ Label ============
    label = {
      uppercase = true,    -- uppercase labels برای بعد از اولین کاراکتر
      exclude = "",        -- labels که استفاده نشن
      current = true,      -- نمایش label برای match زیر cursor
      after = true,        -- label بعد از match
      before = false,      -- label قبل از match
      style = "overlay",   -- "eol", "overlay", "right_align", "inline"
      reuse = "lowercase", -- "lowercase", "all", "none"
      distance = true,     -- فاصله تا match
      min_pattern_length = 0, -- حداقل طول pattern برای نمایش labels
      rainbow = {
        enabled = false,   -- رنگ‌های rainbow
        shade = 5,         -- تعداد رنگ‌ها
      },
      format = function(opts)
        return { { opts.match.label, opts.hl_group } }
      end,
    },

    -- ============ Highlight ============
    highlight = {
      backdrop = true, -- dim کردن بقیه متن
      matches = true, -- highlight کردن matchها
      priority = 5000, -- priority برای extmarks
      groups = {
        match = "FlashMatch",
        current = "FlashCurrent",
        backdrop = "FlashBackdrop",
        label = "FlashLabel",
      },
    },

    -- ============ Modes ============
    modes = {
      -- جستجوی معمولی
      search = {
        enabled = true, -- فعال بودن / و ? jumps
        highlight = { backdrop = false },
        jump = { history = true, register = true, nohlsearch = true },
        search = {
          mode = "search",
          incremental = false,
        },
      },

      -- کاراکتر mode (مثل f, t)
      char = {
        enabled = true,
        config = function(opts)
          -- autohide flash وقتی در operator-pending mode هستی
          opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")

          -- disable jump labels وقتی بیش از max_length نیست
          opts.jump_labels = opts.jump_labels
          and vim.v.count == 0
          and vim.fn.reg_executing() == ""
          and vim.fn.reg_recording() == ""

          -- نمایش jump labels در operator-pending mode
          if opts.autohide then
            opts.jump_labels = false
          end
        end,
        autohide = false,
        jump_labels = false,
        multi_line = true,
        label = { exclude = "hjkliardc" },
        keys = { "f", "F", "t", "T", ";", "," },
        char_actions = function(motion)
          return {
            [";"] = "next", -- set to `right` to always go right
            [","] = "prev", -- set to `left` to always go left
            [motion:lower()] = "next",
            [motion:upper()] = "prev",
          }
        end,
        search = { wrap = false },
        highlight = { backdrop = true },
        jump = { register = false },
      },

      -- Treesitter mode
      treesitter = {
        labels = "abcdefghijklmnopqrstuvwxyz",
        jump = { pos = "range" },
        search = { incremental = false },
        label = { before = true, after = true, style = "inline" },
        highlight = {
          backdrop = false,
          matches = false,
        },
      },

      -- Treesitter search
      treesitter_search = {
        jump = { pos = "range" },
        search = { multi_window = true, wrap = true, incremental = false },
        remote_op = { restore = true },
        label = { before = true, after = true, style = "inline" },
      },

      -- Remote mode
      remote = {
        remote_op = { restore = true, motion = true },
      },
    },

    -- ============ Prompt ============
    prompt = {
      enabled = true,
      prefix = { { "⚡", "FlashPromptIcon" } },
      win_config = {
        relative = "editor",
        width = 1, -- when <=1 it's a percentage of the editor width
        height = 1,
        row = -1, -- when negative it's an offset from the bottom
        col = 0, -- when negative it's an offset from the right
        zindex = 1000,
      },
    },

    -- ============ Remote Flash ============
    remote_op = {
      restore = false,
      motion = false,
    },
  },

  keys = {
    -- ============ Basic Jumps ============
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash",
    },
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash Treesitter",
    },

    -- ============ Remote Flash ============
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Remote Flash",
    },

    -- ============ Treesitter Search ============
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Treesitter Search",
    },

    -- ============ Toggle Flash Search ============
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Toggle Flash Search",
    },
  },

  config = function(_, opts)
    require("flash").setup(opts)

    -- ============ Custom Highlights ============
    vim.api.nvim_set_hl(0, "FlashBackdrop", { fg = "#545c7e" })
    vim.api.nvim_set_hl(0, "FlashMatch", { bg = "#3d59a1", fg = "#c0caf5", bold = true })
    vim.api.nvim_set_hl(0, "FlashCurrent", { bg = "#ff007c", fg = "#c0caf5", bold = true })
    vim.api.nvim_set_hl(0, "FlashLabel", { bg = "#ff007c", bold = true, fg = "#c0caf5" })
    vim.api.nvim_set_hl(0, "FlashPrompt", { bg = "#1a1b26", fg = "#c0caf5" })
    vim.api.nvim_set_hl(0, "FlashPromptIcon", { fg = "#ff007c" })

    -- ============ Integration با which-key ============
    local wk_ok, wk = pcall(require, "which-key")
    if wk_ok then
      wk.add({
        { "s", desc = "Flash Jump" },
        { "S", desc = "Flash Treesitter" },
        { "r", mode = "o",               desc = "Remote Flash" },
        { "R", mode = { "o", "x" },      desc = "Treesitter Search" },
      })
    end
  end,
}
