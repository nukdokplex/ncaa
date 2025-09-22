{ pkgs, lib, ... }:
{
  plugins = {
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
        };
        pylsp = {
          # python
          enable = true;
          pythonPackage = pkgs.python312;
        };
      };
    };

    conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          lspFallback = true;
          timeoutMs = 500;
        };
        formatter_by_ft = {
          bash = [
            "shellcheck"
            "shellharden"
            "shfmt"
          ];
          nix = [
            "deadnix"
            "nixfmt-rfc-style"
          ];
          rust = [
            "rust_analyzer"
          ];
        };
        log_level = "warn";
        notify_on_error = true;
        notify_no_formatters = false;
        formatters = {
          shellcheck.command = lib.getExe pkgs.shellcheck;
          shfmt.command = lib.getExe pkgs.shfmt;
          shellharden.command = lib.getExe pkgs.shellharden;
          squeeze_blanks.command = lib.getExe' pkgs.coreutils "cat";
          nixfmt-rfc-style.command = lib.getExe pkgs.nixfmt-rfc-style;
          deadnix.command = "${lib.getExe pkgs.deadnix} --edit --quiet";
          rust-analyzer.command = lib.getExe pkgs.rust-analyzer;
        };
      };
    };
  };
}
