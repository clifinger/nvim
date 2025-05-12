local map = function(mode, lhs, rhs, desc)
  local options = {
    noremap = true,
    silent = true,
    desc = desc,
  }
  vim.keymap.set(mode, lhs, rhs, options)
end

-- File Operations
map('n', '<C-s>', '<cmd>w<CR>', 'File: Save Current File')
map('i', '<C-s>', '<Esc><cmd>w<CR>', 'File: Save Current File')
map('v', '<C-s>', '<Esc><cmd>w<CR>', 'File: Save Current File')
map('n', '<C-q>', '<cmd>q<CR>', 'File: Quit Current Window')

-- Editing
map('n', 'x', '"_x', 'Edit: Delete Character (No Yank)')
map('v', '<', '<gv', 'Edit: Indent Line (Visual Mode)')
map('v', '>', '>gv', 'Edit: Unindent Line (Visual Mode)')
map('v', 'p', '"_dP', 'Edit: Paste Without Losing Yank (Visual Mode)')

-- Exit Insert Mode
map('i', 'jj', '<Esc>', 'Exit Insert Mode with jj')
map('i', 'jk', '<Esc>', 'Exit Insert Mode with jk')
map('i', 'kk', '<Esc>', 'Exit Insert Mode with kk')

-- File Explorer (Oil)
map('n', '-', '<cmd>Oil --float<CR>', 'File Explorer: Open Parent Directory (Oil)')

-- Navigation
map('n', '<C-d>', '<C-d>zz', 'Navigate: Scroll Down Half Page (Center)')
map('n', '<C-u>', '<C-u>zz', 'Navigate: Scroll Up Half Page (Center)')
map('n', 'n', 'nzzzv', 'Navigate: Next Search Result (Center)')
map('n', 'Nzzzv', 'Navigate: Previous Search Result (Center)')

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

-- View
map('n', '<leader>lw', '<cmd>set wrap!<CR>', 'View: Toggle Line Wrapping')

-- Diagnostics
map('n', 'gl', function()
  vim.diagnostic.open_float()
  vim.diagnostic.open_float()
end, 'Diagnostics: Show Line Diagnostics')
map('n', '[d', function()
  vim.diagnostic.jump { count = -1 }
end, 'Diagnostics: Go To Previous')
map('n', ']d', function()
  vim.diagnostic.jump { count = 1 }
end, 'Diagnostics: Go To Next')
map('n', '<leader>q', vim.diagnostic.setloclist, 'Diagnostics: Show List')

-- Dial Mappings
map('n', '<C-a>', '<Plug>(dial-increment)', 'Dial: Increment')
map('n', '<C-x>', '<Plug>(dial-decrement)', 'Dial: Decrement')
map('n', 'g<C-a>', 'g<Plug>(dial-increment)', 'Dial: Increment with motion/text object')
map('n', 'g<C-x>', 'g<Plug>(dial-decrement)', 'Dial: Decrement with motion/text object')
map('v', '<C-a>', '<Plug>(dial-increment)', 'Dial: Increment selected range')
map('v', '<C-x>', '<Plug>(dial-decrement)', 'Dial: Decrement selected range')
