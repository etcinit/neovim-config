require('gitsigns').setup({
  on_attach = function(bufnr)
    local gs = require('gitsigns')
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- Hunk navigation
    vim.keymap.set('n', ']h', function()
      if vim.wo.diff then return ']c' end
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { noremap = true, silent = true, buffer = bufnr, expr = true, desc = "Gitsigns: Next hunk" })

    vim.keymap.set('n', '[h', function()
      if vim.wo.diff then return '[c' end
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { noremap = true, silent = true, buffer = bufnr, expr = true, desc = "Gitsigns: Previous hunk" })

    -- Actions
    vim.keymap.set('n', '<leader>hs', gs.stage_hunk, vim.tbl_extend('force', opts, { desc = "Gitsigns: Stage hunk" }))
    vim.keymap.set('n', '<leader>hr', gs.reset_hunk, vim.tbl_extend('force', opts, { desc = "Gitsigns: Reset hunk" }))
    vim.keymap.set('v', '<leader>hs', function() gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, vim.tbl_extend('force', opts, { desc = "Gitsigns: Stage hunk" }))
    vim.keymap.set('v', '<leader>hr', function() gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end, vim.tbl_extend('force', opts, { desc = "Gitsigns: Reset hunk" }))
    vim.keymap.set('n', '<leader>hS', gs.stage_buffer, vim.tbl_extend('force', opts, { desc = "Gitsigns: Stage buffer" }))
    vim.keymap.set('n', '<leader>hu', gs.undo_stage_hunk, vim.tbl_extend('force', opts, { desc = "Gitsigns: Undo stage hunk" }))
    vim.keymap.set('n', '<leader>hR', gs.reset_buffer, vim.tbl_extend('force', opts, { desc = "Gitsigns: Reset buffer" }))
    vim.keymap.set('n', '<leader>hp', gs.preview_hunk, vim.tbl_extend('force', opts, { desc = "Gitsigns: Preview hunk" }))
    vim.keymap.set('n', '<leader>hb', function() gs.blame_line({ full = true }) end, vim.tbl_extend('force', opts, { desc = "Gitsigns: Blame line" }))
    vim.keymap.set('n', '<leader>hd', gs.diffthis, vim.tbl_extend('force', opts, { desc = "Gitsigns: Diff this" }))
  end,
})
