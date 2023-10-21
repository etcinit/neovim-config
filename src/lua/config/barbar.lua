return function()
  local bufferline = require('bufferline')

  bufferline.setup {
    icons = { filetype = { enabled = true } },
  }
end
