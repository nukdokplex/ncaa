{ pkgs, lib, ... }:
{
  lsp = {
    keymaps = [
      {
        key = "gd";
        lspBufAction = "definition";
      }
      {
        key = "gD";
        lspBufAction = "references";
      }
      {
        key = "gt";
        lspBufAction = "type_definition";
      }
      {
        key = "gi";
        lspBufAction = "implementation";
      }
      {
        key = "K";
        lspBufAction = "hover";
      }
      {
        action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count=-1, float=true }) end";
        key = "<leader>k";
      }
      {
        action = lib.nixvim.mkRaw "function() vim.diagnostic.jump({ count=1, float=true }) end";
        key = "<leader>j";
      }
      {
        action = "<CMD>LspStop<Enter>";
        key = "<leader>lx";
      }
      {
        action = "<CMD>LspStart<Enter>";
        key = "<leader>ls";
      }
      {
        action = "<CMD>LspRestart<Enter>";
        key = "<leader>lr";
      }
      {
        action = lib.nixvim.mkRaw "require('telescope.builtin').lsp_definitions";
        key = "gd";
      }
      {
        action = "<CMD>Lspsaga hover_doc<Enter>";
        key = "K";
      }
    ];
  };
  plugins = {
    lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        rust_analyzer = {
          # rust
          enable = true;
          installCargo = false;
          installRustc = false;
          installRustfmt = false;
        };
        nil_ls = {
          # nix
          enable = true;
          settings.formatting.command = [ (lib.escapeShellArg (lib.getExe pkgs.nixfmt-rfc-style)) ];
        };
        pylsp = {
          # python
          enable = true;
          pythonPackage = pkgs.python312;
          settings.formatting.command = [ (lib.escapeShellArg (lib.getExe pkgs.python3Packages.black)) ];
        };
        ts_ls = {
          # typescript
          enable = true;
          settings.formatting.command = [ (lib.escapeShellArg (lib.getExe pkgs.prettier)) ];
        };
        # graphql = {
        #   enable = true;
        # };
      };
    };
  };
}
