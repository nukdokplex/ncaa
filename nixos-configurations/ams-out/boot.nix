{
  boot = {
    kernelParams = [ "boot.shell_on_fail" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
      systemd-boot = {
        enable = true;
      };
    };
  };
}
