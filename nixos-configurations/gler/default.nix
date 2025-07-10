{
  lib',
  ezModules,
  inputs,
  modulesPath,
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
      (modulesPath + "/profiles/qemu-guest.nix") # adds virtio and 9p kernel modules
    ];

  nixpkgs.localSystem.system = "x86_64-linux";
  time.timeZone = "Europe/Moscow";
  system.stateVersion = "25.11";
  hardware.enableAllFirmware = true;

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFnNGUSphRtp3azpcSzvO2Tlm75fmn0YbyEzB9Oa6sLb root@gler";
}
