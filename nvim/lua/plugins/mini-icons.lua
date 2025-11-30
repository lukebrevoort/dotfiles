-- ~/.config/nvim/lua/plugins/mini-icons.lua
return {
  {
    "nvim-mini/mini.icons",
    opts = {
      -- Ensure fallback is disabled so it only uses the glyph font
      style = "glyph",
      -- You can add or override specific icon mappings here
      custom_icons = {
        ["file.lua"] = "", -- Example for overriding a Lua file icon
      },
    },
  },
  {
    "nvim-tree/nvim-web-devicons",
    config = function()
      require("nvim-web-devicons").setup({
        override = {
          lua = {
            icon = "",
            color = "#51a0cf",
            cterm_color = "74",
            name = "Lua",
          },
        },
        default = true,
      })
    end,
  },
}
