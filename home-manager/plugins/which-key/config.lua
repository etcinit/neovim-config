local wk = require("which-key")

wk.setup()

wk.add({
  { "<leader>f", group = "Find" },
  { "<leader>x", group = "Trouble" },
  { "<leader>h", group = "Git Hunks" },
  { "<leader>w", group = "Workspace" },
  { "<leader>d", group = "Debug/Diagnostics" },
  { "<leader>c", group = "Code" },
  { "<leader>s", group = "Symbols" },
  { "<leader>r", group = "Refactor" },
  { "<leader>l", group = "Log" },
  { "g", group = "Go to" },
})
