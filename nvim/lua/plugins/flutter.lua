return {
  {
    "akinsho/flutter-tools.nvim",
    lazy = false, -- Set to false to load on startup
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- Optional, for enhanced vim.ui.select
    },
    config = function()
      require("flutter-tools").setup({})
    end,
  },
}
