{ config, lib, nixpkgs, nixneovim, ... }:

{
  imports = [
    nixneovim.nixosModules.default
  ];

  programs.nixneovim = {
    enable = true;
    #colorschemes.catppuccin.enable = true;
    #colorschemes.catppuccin.flavour = "macchiato";

    options = {
      number = true;         # Show line numbers
      wrap = false;

      shiftwidth = 2;        # Tab width should be 2
    };

    plugins = {
      #direnv.enable = true;
      lightline.enable = true;
      treesitter = {
        enable = true;
        indent = true;
      };

      lspconfig = {
        enable = true;
        servers = {
          bashls.enable = true;
          clangd.enable = true;
          cssls.enable = true;
          eslint.enable = true;
        };
      };
    };
  };
}
