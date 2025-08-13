{
  boot = {
    kernelParams = [ "preempt=full" ];
    initrd = {
      enable = true;
      includeDefaultModules = true;
      network.enable = true;
      systemd.enable = true;
      kernelModules = [ "amdgpu" ]; # because i want make correct modeset early
    };
    kernelModules = [
      "kvm-amd"
      "amdgpu"
    ];
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        useOSProber = true; # searches for other operating systems
        device = "nodev"; # we don't need it on efi systems
      };
    };
  };
}
