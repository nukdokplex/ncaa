{
  pkgs,
  lib,
  ezModules,
  inputs,
  modulesPath,
  ...
}:
{
  imports =
    inputs.self.lib.umport {
      path = ./modules;
    }
    ++ [
      ezModules.common-base
      inputs.simple-nixos-mailserver.nixosModule
      (modulesPath + "/profiles/qemu-guest.nix") # adds virtio and 9p kernel modules
    ];

  nixpkgs.hostPlatform = "x86_64-linux";
  time.timeZone = "Europe/Amsterdam";
  system.stateVersion = "25.05";
  hardware.enableAllFirmware = true;

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKe9E7Kw34WZQl7T0MluQd3tKvdhNvEcvDJa9Zr3hJWv root@falhofnir";
}
