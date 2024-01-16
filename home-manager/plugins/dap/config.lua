local setup_dap = function()
  local dap = require "dap"
  local map = require('lib.utils').map

  dap.configurations.lua = {
    {
      type = 'nlua',
      request = 'attach',
      name = "Attach to running Neovim instance",
      host = function()
        local value = vim.fn.input('Host [127.0.0.1]: ')
        if value ~= "" then
          return value
        end
        return '127.0.0.1'
      end,
      port = function()
        local val = tonumber(vim.fn.input('Port: '))
        assert(val, "Please provide a port number")
        return val
      end,
    }
  }

  dap.adapters.nlua = function(callback, config)
    callback({ type = 'server', host = config.host, port = config.port })
  end

  map('n', '<F5>', dap.continue, { noremap = true })
  map('n', '<F10>', dap.step_over, { noremap = true })
  map('n', '<F11>', dap.step_into, { noremap = true })
  map('n', '<F12>', dap.step_out, { noremap = true })
  map('n', '<leader>b', dap.toggle_breakpoint, { noremap = true })
  map(
    'n',
    '<leader>B',
    function()
      dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
    end,
    { noremap = true }
  )
  map(
    'n',
    '<leader>lp',
    function()
      dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
    end,
    { noremap = true }
  )
  map('n', '<leader>dr', dap.repl.open, { noremap = true })
  map('n', '<leader>dl', dap.run_last, { noremap = true })
end

setup_dap()
