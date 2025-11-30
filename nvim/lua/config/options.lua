-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Performance
vim.opt.updatetime = 250 -- Faster completion (default: 4000)
vim.opt.timeoutlen = 300 -- Faster which-key popup (default: 1000)

-- Editor behavior
vim.opt.conceallevel = 2 -- Hide markup in markdown (better for Avante)
vim.opt.confirm = true -- Confirm to save changes before exiting
vim.opt.undofile = true -- Persistent undo
vim.opt.undolevels = 10000 -- Maximum number of undo levels

-- UI improvements
vim.opt.signcolumn = "yes" -- Always show sign column (prevents text shift)
vim.opt.cursorline = true -- Highlight current line
vim.opt.number = true -- Show line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.wrap = false -- Don't wrap lines

-- Search
vim.opt.ignorecase = true -- Ignore case in search patterns
vim.opt.smartcase = true -- Override ignorecase if search contains uppercase

-- Indentation (moved from init.lua)
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 2 -- Size of indent
vim.opt.tabstop = 2 -- Number of spaces tabs count for

-- Clipboard
vim.opt.clipboard = "unnamedplus" -- Sync with system clipboard

-- Splits
vim.opt.splitright = true -- Put new windows right of current
vim.opt.splitbelow = true -- Put new windows below current
