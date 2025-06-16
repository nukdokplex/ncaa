{ inputs, flakeRoot, ... }:
{
  perSystem =
    {
      pkgs,
      system,
      config,
      ...
    }:
    {
      checks.pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = flakeRoot;
        hooks = {
          treefmt = {
            enable = true;
            settings = {
              fail-on-change = true;
              no-cache = true;
              formatters = [ config.formatter ];
            };
          };
        };
      };
    };
}
