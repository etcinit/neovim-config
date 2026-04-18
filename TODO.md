# Neovim Config Improvements

## P0 — Keybinding Conflict

- [x] **`<leader>e` is double-mapped.** nvim-tree maps it to toggle the file tree (`nvim-tree/config.lua:241`), and the LspAttach autocmd maps it to `vim.diagnostic.open_float` (`lspconfig/config.lua:86`). The LSP one wins in any buffer with an attached server, silently breaking tree toggle.

## P1 — Dead Code / No-ops

- [x] **`home-manager/plugins/lsp-status/` still exists on disk.** The import was removed from `default.nix` but the directory with `default.nix` and `config.lua` remains. Should be deleted.
- [x] **null-ls does nothing.** `null-ls/config.lua` is `require('null-ls').setup({})` — zero sources configured. It adds startup cost with no effect. Either configure sources or remove it.
- [x] **conform plugin is a stub.** `home-manager/plugins/conform/default.nix` exists with no `config.lua` and isn't imported in `default.nix`. Either finish it or remove it.

## P2 — Unmaintained / Outdated Plugins

- [x] **prettier.nvim is archived.** Fetched from GitHub at a June 2023 commit (`home-manager/plugins/prettier/default.nix:11`). The repo is no longer maintained. conform.nvim is the standard replacement for formatting, and the stub already exists in this config.
- [x] **one-small-step-for-vimkind pinned to a March 2023 commit** (`home-manager/plugins/one-small-step-for-vimkind/default.nix:10`). Check if nixpkgs has a `vimPlugins` entry for it to avoid manual `fetchFromGitHub` pinning.

## P3 — Redundant / Unnecessary Configuration

- [x] **`syntax on` and `filetype plugin indent on` are Neovim defaults.** These have been enabled by default since Neovim 0.8. The two `vim.api.nvim_command` calls in `home-manager/default.nix:44-45` can be removed.
- [x] **Custom `ftdetect/typescript.lua` is unnecessary.** Neovim's built-in filetype detection already handles `.tsx` files. The custom detection (`src/ftdetect/typescript.lua`) may also conflict with or duplicate the built-in.
- [x] **`vim.o.showmode = false` without lualine mode section.** Verified: lualine's default `lualine_a` shows the mode, so disabling the built-in showmode is correct.

## P4 — Modernization

- [ ] **Deprecated `devShell` flake attribute.** `nix flake check` already warns about this. Change `devShell` to `devShells.default` in `flake.nix:143`.
- [ ] **`vim.api.nvim_command()` should be `vim.cmd()`.** Used in `home-manager/default.nix:44-45` (if kept) and the tokyonight colorscheme line. `vim.cmd` is the idiomatic API since Neovim 0.7.
- [ ] **Command-mode typo remaps use `nvim_command`.** `src/lua/mappings.lua:4-8` defines `:W`, `:Q`, etc. using `vim.api.nvim_command("command ...")`. These should use `vim.api.nvim_create_user_command()`.

## P5 — Missed Opportunities

- [ ] **gitsigns has no keybindings.** `gitsigns/config.lua` is just `require('gitsigns').setup()`. Common bindings like hunk navigation (`]c`/`[c`), stage hunk, blame line, etc. are missing.
- [ ] **dap-ui isn't wired to dap events.** `dap-ui/config.lua` is just `require('dapui').setup()`. Typically you'd add listeners to auto-open/close the UI on debug session start/end.
- [ ] **barbar has minimal config.** Only sets filetype icons. Consider adding close button behavior, animation settings, or sort order if the defaults don't match your preferences.
