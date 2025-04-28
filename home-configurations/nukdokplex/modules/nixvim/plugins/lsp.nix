{ pkgs, lib, ... }:
{
  programs.nixvim.plugins = {
    lsp-format = {
      enable = true;
      lspServersToEnable = "all";
    };

    lsp = {
      enable = true;

      inlayHints = true;

      keymaps = {
        silent = true;
        diagnostic = {
          # Navigate in diagnostics
          "<leader>k" = "goto_prev";
          "<leader>j" = "goto_next";
        };

        lspBuf = {
          K = "hover";
          gD = "references";
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
        };
      };

      servers = {
        nil_ls = {
          enable = true;
          settings.formatting.command = [ (lib.escapeShellArg (lib.getExe pkgs.nixfmt-rfc-style)) ];
        };
        pylsp = {
          enable = true;
          pythonPackage = pkgs.python312;
        };
      };
    };
  };
}
