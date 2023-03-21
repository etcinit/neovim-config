# ✏️ neovim-config

My personal [Neovim][1] configuration as a [home-manager][2] module.

![](./screenshot.png)

## Overview

- Reproducible environment thanks to [Nix][5] and [lazy.nvim][6]
- Can be used standalone or imported in a home-manager configuration.
- Available as a VM for trying out the configuration and testing.
- Focused on Rust, Typescript, and Nix development.

## Usage

### Nix Flake

- Review the documentation on using [home-manager with Nix Flakes][7].
- Add a `neovim-config` input to your Flake:

  ```nix
  {
    inputs = {
      nixpkgs.url = "nixpkgs/nixos-22.11";
      # ...
      neovim-config = {
        url = "git+https://gitlab.chromabits.com/etcinit/neovim-config.git";
        inputs.nixpkgs.follows = "nixpkgs";
      };
    };
    # ...
  }
  ```
- Import the module in one of your `home-manager` modules:

  ```nix
  {inputs, ...}:
  {
    # ...
    imports = [
      inputs.neovim-config.nixosModules.home-manager.neovim-config↴
    ];
  }
  ```
- Use `home-manager switch` to apply the new configuration.
- Start `nvim` and run `:Lazy install`.
- If you had another pluging manager set up before, you may want to run `:checkhealth lazy` to check for any issues.

### Standalone

As a fallback, this configuration can be used without `home-manager`. Expect some rough edges. Dependencies will need to be set up manually, and a compatible version of Neovim needs to be installed:

- Install plugin dependencies: `git`, `gcc`, etc.
- Clone this repository.
- Create a soft link between the `src` directory and `~/.config/nvim`.
- Start `nvim` and wait for `lazy.nvim` to install automatically.
- Run `:Lazy install`.

While `lazy-lock.json` will still be used, Neovim and dependency versions are not guaranteed to be compatible.

## Reproducible Environment

When using this configuration as a `home-manager` module, it is possible to build a reproducible environment. Thanks to Nix's reproducible builds and `lazy.nvim`'s `lazy-lock.json` file, this module will always pull the same versions of all packages/plugins, unless the respective Lockfiles are updated.

While `home-manager` offers a module for managing Neovim plugins, I've opted for using `lazy.nvim` as the Neovim plugin manager to allow for this configuration to be usable in environments where Nix is not available or where `home-manager` is not usable.

### `lazy-lock.json`

On first use, the configuration will create a `lazy-lock.json` file from a static copy. This allows the end-user to upgrade plugins over time without sacrificing the reproducible aspect of the configuration.

If a plugin update breaks the configuration, it is possible to revert the lockfile. Simply delete `~/.config/nvim/lazy-lock.json`, restart Neovim, and use the `:Lazy restore` command to revert all plugins to the versions in the Lockfile.

## Development

For a development environment, you can use `nix develop` to open a shell with tools used to work on this module (Lua LSP, `nixos-rebuild`, etc).

The configuration can be tested on an isolated VM or by referencing it locally from another Nix flake.

[Direnv][4] is also pre-configured. Use `direnv allow` to automatically enter the devshell when `cd`-ing to the repository.

### Development VM

Testing the configuration in a VM is the recommended approach since it doesn't alter your current system. The approach uses `nixos-rebuild build-vm` to create and launch a QEMU VM with NixOS and a user pre-configured with home-manager:

- Clone this repository locally.
- Enter the development shell (`nix develop` or use Direnv).
- Build the VM image and script: `nixos-rebuild build-vm --flake .\#vm`.
- Launch the VM: `result/bin/run-nixos-vm`.

**Tips for using the VM:**

- The initial build of the VM image will take a few minutes as Nix downloads cache entries. Subsequent boots take less than 20 seconds on an 11th Gen i7 processor.
- The VM is preconfigured with `neovim` as a user and `example` as a password. This is an insecure setup only provided for convenience. While the VM will run in QEMU usermode, running untrusted software in the VM is not recommended.
- `Ctrl + A C q <ENTER>` can be used to kill the QEMU monitor.
- After the first boot, a `nixos.qcow2` disk image will be created in the repository. This will persist the state of the VM. To start with a fresh environment, `rm nixos.qcow2`.
- Serial console windows won't automatically resize. The VM includes a convenience script, `resize-tty` for updating the window size.

### Nix Flake

- Clone this repository locally.
- From another Nix flake, add an input referencing the repository using a path ([Nix manual on Flake URL-like syntax][3])

[1]: https://neovim.io
[2]: https://github.com/nix-community/home-manager
[3]: https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#url-like-syntax
[4]: https://github.com/direnv/direnv
[5]: https://nixos.org
[6]: https://github.com/folke/lazy.nvim
[7]: https://nix-community.github.io/home-manager/index.html#ch-nix-flakes