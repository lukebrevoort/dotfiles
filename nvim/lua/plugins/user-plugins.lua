return {
  { "nvim-telescope/telescope.nvim", event = "VeryLazy" },
  { "nvim-tree/nvim-tree.lua", event = "VeryLazy" },
  { "lewis6991/gitsigns.nvim", event = { "BufReadPre", "BufNewFile" } },
  { "numToStr/Comment.nvim", event = "VeryLazy" },
  { "kylechui/nvim-surround", event = "VeryLazy", config = true },
  { "akinsho/bufferline.nvim", event = "VeryLazy" },
  { "folke/noice.nvim", event = "VeryLazy" },
  { "folke/which-key.nvim", event = "VeryLazy" },
  { "nvim-tree/nvim-web-devicons" }, -- Keep eager loaded for icons
}
