{ inputs, ... }:
{
  imports = [ inputs.git-hooks-nix.flakeModule ];

  perSystem =
    {
      pkgs,
      config,
      inputs',
      ...
    }:
    {
      pre-commit = {
        check.enable = true;
        settings.hooks = {
          nixfmt-rfc-style.enable = true;
          deadnix = {
            enable = true;
            settings = {
              edit = true;
            };
          };
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
            age-plugin-openpgp-card
            agenix-rekey
            git
            age
            zsh
            pre-commit
            inputs'.deploy-rs.packages.deploy-rs
            inputs'.nixos-anywhere.packages.nixos-anywhere
          ]
          ++ config.pre-commit.settings.enabledPackages;
      };
    };
}
