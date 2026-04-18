local utils = require('lib.utils')
local map = utils.map

-- Command typo aliases
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Q', 'q', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('WQ', 'wq', {})

-- Buffer Navigation
map('', '<S-Up>', '<C-w><Up>')
map('', '<S-Down>', '<C-w><Down>')
map('', '<S-Right>', '<C-w><Right>')
map('', '<S-Left>', '<C-w><Left>')

-- Buffer Switching
map('', 'gn', ':bn<CR>')
map('', 'gp', ':bp<CR>')
map('', 'gd', ':bd<CR>')

-- Tab Switching (Ctrl-Tab)
map('', '<C-Tab>', ':<C-U>tabnext<CR>', { noremap = true })
map('', '<C-S-Tab>', ':<C-U>tabprevious<CR>', { noremap = true })
