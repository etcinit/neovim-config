# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal Neovim configuration packaged as a Nix home-manager module. All plugins and dependencies are managed through Nix (no Lazy.nvim or other runtime plugin managers). The leader key is `,`.

## Development commands

```sh
nix develop              # Enter devshell (lua-language-server, nixfmt-rfc-style)
nix run .                # Quick-test the config in an isolated Neovim instance (NVIM_APPNAME=nvim-config-test)
nix fmt                  # Format all Nix files (nixfmt-tree)
nixos-rebuild build-vm --flake .\#vm  # Build test VM (Linux only)
```

Direnv is pre-configured (`direnv allow` to auto-enter devshell).

## Architecture

The config has two layers that merge at build time:

1. **`home-manager/`** -- Nix layer. `default.nix` is the module entry point, which sets `programs.neovim` options and imports each plugin from `home-manager/plugins/<name>/`. Each plugin directory has:
   - `default.nix` -- declares the Nix plugin package and reads `config.lua` via `builtins.readFile`
   - `config.lua` -- Lua configuration for that plugin, inlined into the generated `init.lua` by home-manager

2. **`src/`** -- Lua runtime files, symlinked into `~/.config/nvim/` by home-manager:
   - `src/lua/options.lua` -- vim options (loaded via `require('options')` in `extraLuaConfig`)
   - `src/lua/mappings.lua` -- global keybindings (loaded via `require('mappings')`)
   - `src/lua/lib/utils.lua` -- `map()` and `map_buf()` helpers for keybinding definitions
   - `src/after/ftplugin/` -- filetype-specific overrides (haskell, markdown, rust)

The generated `init.lua` (from home-manager) sets `mapleader = ","`, then calls `require('options')` and `require('mappings')`.

For `nix run`, `flake.nix` bundles `src/` as a `buildVimPlugin` and evaluates the full home-manager module to extract the neovim package and generated `init.lua`.

## Key conventions

- **Adding a plugin**: create `home-manager/plugins/<name>/default.nix` and `config.lua`, then add the import to `home-manager/default.nix`.
- **Keybindings**: use `require('lib.utils').map` / `map_buf` helpers. Global bindings go in `src/lua/mappings.lua`; LSP bindings are in the `LspAttach` autocmd in `home-manager/plugins/lspconfig/config.lua`. Update which-key groups in `home-manager/plugins/which-key/config.lua` when adding new leader-key groups.
- **Formatting**: conform.nvim handles format-on-save. Nix files use `nixfmt`, web filetypes use `prettierd`, others fall back to LSP formatting.
- **LSP servers** are configured and enabled in `home-manager/plugins/lspconfig/config.lua` (rust_analyzer, hls, nil_ls, ts_ls, eslint, basedpyright, ruff, lua_ls, nixd).
