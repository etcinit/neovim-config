local function map(modes, lhs, rhs, opts, desc)
  opts = opts or {}
  opts.noremap = opts.noremap == nil and true or opts.noremap

  if type(modes) == 'string' then modes = { modes } end

  if type(desc) == 'string' then
    opts = vim.tbl_extend('force', opts, {
      desc = desc
    })
  end

  for _, mode in ipairs(modes) do
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local function map_buf(bufn, modes, lhs, rhs, opts, desc)
  opts = opts or {}

  opts.buffer = bufn

  if type(desc) == 'string' then
    opts = vim.tbl_extend('force', opts, {
      desc = desc
    })
  end

  map(modes, lhs, rhs, opts)
end

return {
  map = map,
  map_buf = map_buf
}
