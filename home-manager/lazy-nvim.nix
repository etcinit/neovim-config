{pkgs, ...}: {
  config = {
    home.file.".local/share/nvim/lazy/lazy.nvim" = {
      source = pkgs.fetchFromGitHub {
        owner = "folke";
        repo = "lazy.nvim";
        rev = "690f9e88e2a7dc92bcb0cca85f778a3e99fe1f7e";
        sha256 = "Sg5dVBtU+o80qzNdhmPCN7viVfEcH5jCYCCTEKzdfAg=";
      };
      target = ".local/share/nvim/lazy/lazy.nvim";
    };
  };
}

