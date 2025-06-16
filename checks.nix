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
          nixfmt-rfc-style.enable = true;
        };
      };
    };
}
