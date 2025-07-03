{
  perSystem =
    { pkgs, config, ... }:
    {
      devShells.default = pkgs.mkShellNoCC {
        name = "default";

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
          ++ config.checks.pre-commit-check.enabledPackages;

        shellHook = config.checks.pre-commit-check.shellHook;
      };
    };
}
