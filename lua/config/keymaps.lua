-- Default options for keymaps
local opts = { noremap = true, silent = true }

-- Utility function for setting keymaps
local map = function(mode, lhs, rhs, desc)
  local options = opts
  options.desc = desc
  vim.keymap.set(mode, lhs, rhs, options)
end

-- General & File Operations
map('n', '-', '<cmd>Oil --float<CR>', 'File Explorer: Open Parent Directory (Oil)')
map('n', '<C-s>', '<cmd>w<CR>', 'File: Save Current File')
map('i', '<C-s>', '<Esc><cmd>w<CR>', 'File: Save Current File')
map('v', '<C-s>', '<Esc><cmd>w<CR>', 'File: Save Current File')
map('n', '<C-q>', '<cmd>q<CR>', 'File: Quit Current Window')
map('n', 'x', '"_x', 'Edit: Delete Character (No Yank)')

-- Navigation & Scrolling
map('n', '<C-d>', '<C-d>zz', 'Navigate: Scroll Down Half Page (Center)')
map('n', '<C-u>', '<C-u>zz', 'Navigate: Scroll Up Half Page (Center)')
map('n', 'n', 'nzzzv', 'Navigate: Next Search Result (Center)')
map('n', 'N', 'Nzzzv', 'Navigate: Previous Search Result (Center)')

-- Window Management
map('n', '<leader>v', '<C-w>v', 'Window: Split Vertically')
map('n', '<leader>h', '<C-w>s', 'Window: Split Horizontally')
map('n', '<leader>se', '<C-w>=', 'Window: Equalize Splits')
map('n', '<leader>xs', '<cmd>close<CR>', 'Window: Close Current Split')
map('n', '<C-k>', '<cmd>wincmd k<CR>', 'Window: Navigate Up')
map('n', '<C-j>', '<cmd>wincmd j<CR>', 'Window: Navigate Down')
map('n', '<C-h>', '<cmd>wincmd h<CR>', 'Window: Navigate Left')
map('n', '<C-l>', '<cmd>wincmd l<CR>', 'Window: Navigate Right')

-- Tab Management
map('n', '<leader>to', '<cmd>tabnew<CR>', 'Tab: Open New Tab')
map('n', '<leader>tx', '<cmd>tabclose<CR>', 'Tab: Close Current Tab')
map('n', '<leader>tn', '<cmd>tabn<CR>', 'Tab: Go To Next Tab')
map('n', '<leader>tp', '<cmd>tabp<CR>', 'Tab: Go To Previous Tab')

-- Visual & Editing Enhancements
map('n', '<leader>lw', '<cmd>set wrap!<CR>', 'View: Toggle Line Wrapping')
map('v', '<', '<gv', 'Edit: Indent Line (Visual Mode)')
map('v', '>', '>gv', 'Edit: Unindent Line (Visual Mode)')
map('v', 'p', '"_dP', 'Edit: Paste Without Losing Yank (Visual Mode)')

-- Diagnostics
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Diagnostics: Show Line Diagnostics' })
vim.keymap.set('n', '[d', function()
  vim.diagnostic.jump { count = -1 }
end, { desc = 'Diagnostics: Go To Previous' })
vim.keymap.set('n', ']d', function()
  vim.diagnostic.jump { count = 1 }
end, { desc = 'Diagnostics: Go To Next' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Diagnostics: Show List' })
