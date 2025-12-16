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
          package = null;
          installCargo = false;
          installRustc = false;
          installRustfmt = false;
        };
        nil_ls = {
          # nix
          enable = true;
          package = null;
          rootMarkers = [ "flake.nix" ];
          settings = {
            formatting.command = [ "nixfmt" ];
            flake = {
              autoArchive = true;
              autoEvalInputs = true;
              nixpkgsInputName = "nixpkgs";
            };
          };
        };
        pylsp = {
          # python
          enable = true;
          pythonPackage = pkgs.python3;
          package = null;
          settings = {
            plugins = {
              pycodestyle = {
                maxLineLength = 88;
                indentSize = 2;
              };
              flake8 = {
                indentSize = 2;
              };
            };
          };
        };
        ts_ls = {
          # typescript
          enable = true;
          package = null;
        };
        # graphql = {
        #   enable = true;
        # };
      };
    };
  };
}
