return {
  -- Catppuccin (Dark Mode)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- dark variant
        integrations = {
          cmp = true,
          gitsigns = true,
          nvimtree = true,
          treesitter = true,
          notify = false,
          mini = true,
          which_key = true,
          avante = true, -- Add Avante integration
        },
      })
    end,
  },

  -- Everforest (Light Mode)
  {
    "neanias/everforest-nvim",
    name = "everforest",
    lazy = false,
    priority = 1000,
    config = function()
      require("everforest").setup({
        background = "soft", -- 'hard', 'medium', or 'soft'
        transparent_background_level = 0,
        italics = true,
        sign_column_background = "none",
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
          vim.cmd.colorscheme("catppuccin")
        end,
        set_light_mode = function()
          vim.api.nvim_set_option_value("background", "light", {})
          vim.cmd.colorscheme("everforest")
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

  -- LazyVim integration - set default to catppuccin
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
}
