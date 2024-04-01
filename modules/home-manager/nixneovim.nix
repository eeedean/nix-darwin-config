{ config, lib, pkgs, nixneovim, ... }:

{
  imports = [
    nixneovim.nixosModules.default
  ];

  programs.nixneovim = {
    enable = true;
    globals.mapleader = " ";

    options = {
      number = true;         # Show line numbers
      wrap = false;

      shiftwidth = 2;        # Tab width should be 2
    };

    plugins = {
      lightline.enable = true;
      telescope.enable = true;
      treesitter = {
        enable = true;
        indent = true;
      };

      nvim-cmp = {
        enable = true;
        snippet.luasnip.enable = true;
        completion = {
          keyword_length = 1;
          keyword_pattern = ".*";
        };
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
    mappings = {
      normal = {
        "<leader>e" = { action = "'<cmd>:Explore<CR>'"; };
        "<leader>q" = { action = "'<cmd>:q<CR>'"; };
        "<leader>h" = { action = "'<cmd>:split<CR>'"; };
        "<leader>v" = { action = "'<cmd>:vsplit<CR>'"; };

        "<leader>ff" = { action = "require('telescope.builtin').find_files"; };
        "<leader>fg" = { action = "require('telescope.builtin').live_grep"; };
        "<leader>fb" = { action = "require('telescope.builtin').buffers"; };
        "<leader>fh" = { action = "require('telescope.builtin').help_tags"; };

        "<leader><Right>" = { action = "'<cmd>:vertical resize +5<CR>'"; };
        "<leader><Left>" = { action = "'<cmd>:vertical resize -5<CR>'"; };
        "<leader><Up>" = { action = "'<cmd>:resize +5<CR>'"; };
        "<leader><Down>" = { action = "'<cmd>:resize -5<CR>'"; };
      };
    };

    extraPlugins = [
      pkgs.vimPlugins.ale
    ];
  };
}
