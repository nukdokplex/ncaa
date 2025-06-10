{
  pkgs,
  lib',
  ezModules,
  inputs,
  modulesPath,
  ...
}:
{
  imports =
    lib'.umport {
      path = ./modules;
    }
    ++ [
      ezModules.common-base
      ezModules.dyndns
      inputs.simple-nixos-mailserver.nixosModule
      (modulesPath + "/profiles/qemu-guest.nix") # adds virtio and 9p kernel modules
    ];

  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "Europe/Moscow";
  system.stateVersion = "25.05";
  hardware.enableAllFirmware = true;

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIP0Poub88wn1QfOpm4vL/5MWMTf9Om+w2KkoBHncN+9d root@gler";
}
