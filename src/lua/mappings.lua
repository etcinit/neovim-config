local utils = require('lib.utils')
local map = utils.map

-- Make life easier
map('n', ':W', ':w')
map('n', ':Q', ':q')
map('n', ':wQ', ':wq')
map('n', ':WQ', ':wq')
map('n', ':Wq', ':wq')

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
