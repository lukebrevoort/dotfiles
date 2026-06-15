return {
  -- Kanagawa (dark/light variants)
  {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup({
        theme = "dragon",
        background = {
          dark = "dragon",
          light = "lotus",
        },
      })
    end,
  },

  -- Auto theme detection and switching
  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 999, -- Load after themes but before LazyVim applies colorscheme
    config = function()
      local auto_dark_mode = require("auto-dark-mode")

      auto_dark_mode.setup({
        update_interval = 5000,
        set_dark_mode = function()
          vim.api.nvim_set_option_value("background", "dark", {})
          vim.cmd("colorscheme kanagawa")
        end,
        set_light_mode = function()
          vim.api.nvim_set_option_value("background", "light", {})
          vim.cmd("colorscheme kanagawa")
        end,
      })

      -- Initialize immediately
      auto_dark_mode.init()

      -- Also ensure it applies after LazyVim finishes loading
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          vim.schedule(function()
            auto_dark_mode.init()
          end)
        end,
      })
    end,
  },

  -- LazyVim integration - set default to kanagawa
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa",
    },
  },
}
