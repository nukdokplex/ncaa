{ pkgs, ... }: {
  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    initrd = {
      enable = true;
      includeDefaultModules = true;
      network.enable = true;
      systemd.enable = true;
      kernelModules = [ "amdgpu" ]; # because i want make correct modeset early
    };
    kernelModules = [ "kvm-amd" "amdgpu" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true;
        device = "nodev"; # this affects only BIOS system
      };
    };
  };
}
