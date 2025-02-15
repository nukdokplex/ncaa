{
  boot = {
    initrd = {
      enable = true;
      includeDefaultModules = true;
      network.enable = true;
      kernelModules = [ "amdgpu" ]; # because i want make correct modeset early
      systemd.enable = true;
    };
    kernelModules = [ "kvm-amd" "amdgpu" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      grub = {
        efiSupport = true;
        useOSProber = true;
        device = "nodev"; # this affects only BIOS system
      };
    };
  };
}
