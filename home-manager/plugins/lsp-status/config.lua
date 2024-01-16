local setup_lspstatus = function()
  local lsp_status = require('lsp-status')

  local kind_labels_mt = {
    __index = function(_, k)
      return k
    end
  }
  local kind_labels = {}

  setmetatable(kind_labels, kind_labels_mt)

  lsp_status.register_progress()
  lsp_status.config({
    kind_labels = kind_labels,
    indicator_errors = "×",
    indicator_warnings = "!",
    indicator_info = "i",
    indicator_hint = "›",
    status_symbol = "",
  })
end

setup_lspstatus()
