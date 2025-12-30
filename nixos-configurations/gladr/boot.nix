{ pkgs, config, ... }:
{
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelParams = [ "preempt=full" ];
    initrd = {
      enable = true;
      includeDefaultModules = true;
      network.enable = true;
      systemd.enable = true;
    };
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = config.disko.devices.disk.main.content.partitions.ESP.content.mountpoint;
      };
      grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true; # searches for other operating systems
        device = "nodev"; # we don't need it on efi systems
      };
    };
  };
}
