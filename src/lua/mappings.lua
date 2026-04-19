local utils = require('lib.utils')
local map = utils.map

-- Command typo aliases
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Q', 'q', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('WQ', 'wq', {})

-- Buffer Navigation
map('', '<S-Up>', '<C-w><Up>', {}, "Window: Move up")
map('', '<S-Down>', '<C-w><Down>', {}, "Window: Move down")
map('', '<S-Right>', '<C-w><Right>', {}, "Window: Move right")
map('', '<S-Left>', '<C-w><Left>', {}, "Window: Move left")

-- Buffer Switching
map('', 'gn', ':bn<CR>', {}, "Buffer: Next")
map('', 'gp', ':bp<CR>', {}, "Buffer: Previous")
map('n', '<leader>bd', ':bd<CR>', {}, "Buffer: Delete")

-- Tab Switching (Ctrl-Tab)
map('', '<C-Tab>', ':<C-U>tabnext<CR>', { noremap = true }, "Tab: Next")
map('', '<C-S-Tab>', ':<C-U>tabprevious<CR>', { noremap = true }, "Tab: Previous")
