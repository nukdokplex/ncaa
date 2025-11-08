{ ... }:

{
  plugins.lint = {
    enable = true;

    lintersByFt = {
      nix = [ "statix" ];

      python = [ "flake8" ];

      javascript = [ "eslint_d" ];
      javascriptreact = [ "eslint_d" ];
      typescript = [ "eslint_d" ];
      typescriptreact = [ "eslint_d" ];

      dockerfile = [ "hadolint" ];
    };
  };
}
