{ inputs, pkgs, lib, ... }: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  environment.systemPackages = with pkgs; [
    sbctl
  ];

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
      systemd-boot.enable = lib.mkForce false;
    };
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
