local function map(modes, lhs, rhs, opts)
  opts = opts or {}
  opts.noremap = opts.noremap == nil and true or opts.noremap

  if type(modes) == 'string' then modes = { modes } end

  for _, mode in ipairs(modes) do
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

local function map_buf(bufn, modes, lhs, rhs, opts)
  opts = opts or {}

  opts.buffer = bufn

  map(modes, lhs, rhs, opts)
end

return {
  map = map,
  map_buf = map_buf
}
