{
  inputs,
  pkgs,
  lib,
  config,
  flakeRoot,
  ...
}:
{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];

  environment.systemPackages = with pkgs; [
    sbctl
  ];

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
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

  age.secrets = {
    sb_GUID.path = "/var/lib/sbctl/GUID";
    sb_KEK_private.path = "/var/lib/sbctl/keys/KEK/KEK.key";
    sb_KEK_public.path = "/var/lib/sbctl/keys/KEK/KEK.pem";
    sb_PK_private.path = "/var/lib/sbctl/keys/PK/PK.key";
    sb_PK_public.path = "/var/lib/sbctl/keys/PK/PK.pem";
    sb_db_private.path = "/var/lib/sbctl/keys/db/db.key";
    sb_db_public.path = "/var/lib/sbctl/keys/db/db.pem";
  };
}
