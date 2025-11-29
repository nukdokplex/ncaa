{
  lib',
  lib,
  ezModules,
  inputs,
  config,
  ...
}:
{
  imports =
    lib'.umport {
      path = ./.;
      exclude = [
        ./default.nix
        ./xray.nix
      ];
      recursive = false;
    }
    ++ (with ezModules; [
      base-system
      acme
      nukdokplex
      russian-locale
    ]);

  time.timeZone = "Europe/Amsterdam";
  system.stateVersion = "25.05";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKe9E7Kw34WZQl7T0MluQd3tKvdhNvEcvDJa9Zr3hJWv root@falhofnir";

  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.nukdokplex.openssh.authorizedKeys.keys;
  nixpkgs.overlays = lib.singleton inputs.self.overlays.light-packages;
}
