{ pkgs, ... }:
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
        efiSysMountPoint = "/boot/efi";
      };
      systemd-boot = {
        enable = true;
        memtest86 = {
          enable = true;
          sortKey = "z_memtest86";
        };
      };
      # grub = {
      #   enable = true;
      #   efiSupport = true;
      #   enableCryptodisk = true;
      #   useOSProber = false; # searches for other operating systems
      #   device = "nodev"; # we don't need it on efi systems
      # };
    };
  };
}
