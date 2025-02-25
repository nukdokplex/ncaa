{
  boot = {
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
        useOSProber = true;
        device = "nodev"; # this affects only legacy boot
      };
    };
  };
}
