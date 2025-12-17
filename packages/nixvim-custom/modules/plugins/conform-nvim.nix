{ ... }:
{
  plugins.conform-nvim = {
    enable = true;
    autoInstall = {
      enable = true;
    };
    settings = {
      formatters_by_ft = {
        bash = [
          "shellcheck"
          "shellharden"
          "shfmt"
        ];

        nix = [ "nixfmt" ];

        markdown = [ "mdformat" ];

        javascript = [ "prettierd" ];
        typescript = [ "prettierd" ];
        typescriptreact = [ "prettierd" ];
        graphql = [ "prettierd" ];
        css = [ "prettierd" ];
        html = [ "prettierd" ];

        yaml = [ "prettierd" ];
        json = [ "jsonfmt" ];

        python = [
          "isort"
          "black"
        ];

        dockerfile = [ "dockerfmt" ];
      };
    };
  };
}
