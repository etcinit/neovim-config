local utils = require('lib.utils')
local map = utils.map

-- Command typo aliases
vim.api.nvim_create_user_command('W', 'w', {})
vim.api.nvim_create_user_command('Q', 'q', {})
vim.api.nvim_create_user_command('Wq', 'wq', {})
vim.api.nvim_create_user_command('WQ', 'wq', {})

-- Clear search highlight
map('n', '<Esc>', '<cmd>nohlsearch<CR>', {}, "Clear search highlight")

-- Window Navigation
map('', '<S-Up>', '<C-w><Up>', {}, "Window: Move up")
map('', '<S-Down>', '<C-w><Down>', {}, "Window: Move down")
map('', '<S-Right>', '<C-w><Right>', {}, "Window: Move right")
map('', '<S-Left>', '<C-w><Left>', {}, "Window: Move left")
map('n', '<C-h>', '<C-w>h', {}, "Window: Move left")
map('n', '<C-j>', '<C-w>j', {}, "Window: Move down")
map('n', '<C-k>', '<C-w>k', {}, "Window: Move up")
map('n', '<C-l>', '<C-w>l', {}, "Window: Move right")

-- Buffer Switching
map('n', '<S-l>', ':bn<CR>', {}, "Buffer: Next")
map('n', '<S-h>', ':bp<CR>', {}, "Buffer: Previous")
map('n', '<leader>bd', ':bd<CR>', {}, "Buffer: Delete")

-- Move lines up/down
map('n', '<A-j>', '<cmd>m .+1<CR>==', {}, "Move: Line down")
map('n', '<A-k>', '<cmd>m .-2<CR>==', {}, "Move: Line up")
map('v', '<A-j>', ":m '>+1<CR>gv=gv", {}, "Move: Selection down")
map('v', '<A-k>', ":m '<-2<CR>gv=gv", {}, "Move: Selection up")

-- Better indenting (stay in visual mode)
map('v', '<', '<gv', {}, "Indent: Dedent and reselect")
map('v', '>', '>gv', {}, "Indent: Indent and reselect")

-- Terminal
map('t', '<Esc><Esc>', '<C-\\><C-n>', {}, "Terminal: Exit terminal mode")

-- Tab Switching (Ctrl-Tab)
map('', '<C-Tab>', ':<C-U>tabnext<CR>', { noremap = true }, "Tab: Next")
map('', '<C-S-Tab>', ':<C-U>tabprevious<CR>', { noremap = true }, "Tab: Previous")
