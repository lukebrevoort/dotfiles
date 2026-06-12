-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Better escape (exit insert mode quickly)
vim.keymap.set("i", "jk", "<ESC>", { noremap = true, silent = true, desc = "Exit insert mode" })

-- Navigation improvements
vim.keymap.set("n", "E", "$", { noremap = true, desc = "Jump to end of line" })
vim.keymap.set("n", "B", "^", { noremap = true, desc = "Jump to beginning of line" })
vim.keymap.set("n", "L", "<C-f>", { noremap = true, silent = true, desc = "Page down" })
vim.keymap.set("n", "H", "<C-b>", { noremap = true, silent = true, desc = "Page up" })

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Better indenting (stay in visual mode)
vim.keymap.set("v", "<", "<gv", { noremap = true, desc = "Indent left" })
vim.keymap.set("v", ">", ">gv", { noremap = true, desc = "Indent right" })

-- Move lines up/down
vim.keymap.set("n", "<C-S-j>", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move line down" })
vim.keymap.set("n", "<C-S-k>", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up" })
vim.keymap.set("v", "<C-S-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection down" })
vim.keymap.set("v", "<C-S-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move selection up" })

-- Better paste (don't yank replaced text in visual mode)
vim.keymap.set("v", "p", '"_dP', { noremap = true, desc = "Paste without yanking" })

-- Clear search highlighting
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { noremap = true, silent = true, desc = "Clear search highlight" })

-- Quick save
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

-- Better split management
vim.keymap.set("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
vim.keymap.set("n", "<leader>|", "<C-W>v", { desc = "Split window right" })
