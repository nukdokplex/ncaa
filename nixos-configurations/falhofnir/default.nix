{
  lib',
  lib,
  ezModules,
  inputs,
  ...
}:
{
  imports =
    lib'.umport {
      path = ./.;
      exclude = [ ./default.nix ];
      recursive = false;
    }
    ++ [
      ezModules.common-base
      ezModules.acme
      inputs.simple-nixos-mailserver.nixosModule
    ];

  time.timeZone = "Europe/Amsterdam";
  system.stateVersion = "25.05";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKe9E7Kw34WZQl7T0MluQd3tKvdhNvEcvDJa9Zr3hJWv root@falhofnir";

  nixpkgs.overlays = lib.singleton inputs.self.overlays.light-packages;
}
