return {
  {
    "NickvanDyke/opencode.nvim",
    version = "*",
    dependencies = {
      {
        "folke/snacks.nvim",
        optional = true,
        opts = {
          input = {},
          picker = {
            actions = {
              opencode_send = function(...)
                return require("opencode").snacks_picker_send(...)
              end,
            },
            win = {
              input = {
                keys = {
                  ["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
                },
              },
            },
          },
          terminal = {},
        },
      },
    },
    keys = {
      { "<leader>a", desc = "AI/Opencode" },
      {
        "<leader>ao",
        function()
          require("opencode").toggle()
        end,
        desc = "Toggle",
      },
      {
        "<leader>ap",
        function()
          require("opencode").ask("@file @cursor: ")
        end,
        desc = "Prompt (@file @cursor)",
      },
      {
        "<leader>as",
        function()
          return require("opencode").operator("@this ")
        end,
        mode = { "n", "x" },
        expr = true,
        desc = "Send Selection",
      },
      {
        "<leader>ad",
        function()
          require("opencode").prompt("diagnostics")
        end,
        desc = "Diagnostics",
      },
      {
        "<leader>af",
        function()
          require("opencode").ask("@file: ")
        end,
        desc = "File",
      },
      {
        "<leader>aq",
        function()
          require("opencode").prompt("@quickfix")
        end,
        desc = "Quickfix",
      },
      {
        "<leader>an",
        function()
          require("opencode").ask("/new", { submit = true })
        end,
        desc = "New Session (/new)",
      },
    },
    config = function()
      vim.o.autoread = true
    end,
  },
}
