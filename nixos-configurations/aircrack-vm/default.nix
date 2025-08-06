{
  lib',
  lib,
  ezModules,
  inputs,
  modulesPath,
  pkgs,
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
      (modulesPath + "/profiles/qemu-guest.nix") # adds virtio and 9p kernel modules
    ];

  nixpkgs.localSystem.system = "x86_64-linux";
  time.timeZone = "Asia/Yekaterinburg";
  system.stateVersion = "25.11";
  hardware.enableAllFirmware = true; # for wifi adapters

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQL3nexvTK4ShR2Nxz5DEmzcFOw7BYWJP0AUV8Bcnw+ root@aircrack-vm";

  nixpkgs.overlays = lib.singleton inputs.self.overlays.light-packages;

  environment.systemPackages = with pkgs; [ aircrack-ng ];
}
