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
            rage
            zsh
          ]
          ++ config.checks.pre-commit-check.enabledPackages;

        inputsFrom = [ ];

        shellHook =
          config.checks.pre-commit-check.shellHook
          + ''
            export SHELL=$(which zsh)
            exec $SHELL -i
            echo "You are in devshell, cowboy!
          '';
      };
    };
}
