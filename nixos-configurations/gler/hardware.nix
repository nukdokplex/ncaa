{ modulesPath, ... }:
{
  nixpkgs.localSystem.system = "x86_64-linux";

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix") # adds virtio and 9p kernel modules
  ];

  hardware.enableRedistributableFirmware = false;
}
