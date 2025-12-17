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
        ./wireguard.nix
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
  system.stateVersion = "25.11";

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFWHEtir/gfekSJdakG6ai2i/wImviQifNV3eVv431T4 root@falhofnir";

  users.users.root.openssh.authorizedKeys.keys =
    config.users.users.nukdokplex.openssh.authorizedKeys.keys;
  nixpkgs.overlays = lib.singleton inputs.self.overlays.light-packages;
}
