{ inputs, ... }:
{
  imports = [ inputs.git-hooks-nix.flakeModule ];

  perSystem =
    { pkgs, config, ... }:
    {
      pre-commit = {
        check.enable = true;
        settings.hooks = {
          nixfmt-rfc-style.enable = true;
          deadnix.enable = true;
        };
      };

      devShells.default = pkgs.mkShellNoCC {
        name = "default";

        shellHook = config.pre-commit.installationScript + ''
          export NH_FLAKE="path:$(pwd)"
        '';

        packages =
          with pkgs;
          [
            age-plugin-fido2-hmac
            age-plugin-yubikey
            agenix-rekey
            git
            age
            zsh
          ]
          ++ config.pre-commit.settings.enabledPackages;
      };
    };
}
