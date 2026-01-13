{
  lib,
  inputs,
  config,
  ...
}:
{
  nixpkgs.localSystem.system = "x86_64-linux";

  imports = [
    (inputs.nixos-hardware + /common/cpu/amd)
    (inputs.nixos-hardware + /common/cpu/amd/pstate.nix)
    (inputs.nixos-hardware + /common/cpu/amd/zenpower.nix)
    (inputs.nixos-hardware + /common/gpu/amd)
    (inputs.nixos-hardware + /common/pc/laptop)
    (inputs.nixos-hardware + /common/pc/laptop/hdd)
    (inputs.nixos-hardware + /common/pc/ssd)
  ];

  hardware.enableRedistributableFirmware = true;

  services.fprintd.enable = true;

  services.logind.settings.Login = {
    HandlePowerKey = "poweroff";
    HandleRebootKey = "reboot";
    HandleSuspendKey = "suspend-then-hibernate";
    HandleSuspendKeyLongPress = "suspend";
    HandleHibernateKey = "hibernate";
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "lock";
    HandleLidSwitchDocked = "ignore";
    HandleSecureAttentionKey = "lock";
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=yes
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no

    # SuspendState=
    # HibernateMode=
    # MemorySleepMode=

    HibernateOnACPower=no

    #HibernateDelaySec=30min
    #SuspendEstimationSec=10min
  '';

  powerManagement.powertop.enable = true;

  nixpkgs.config.rocmSupport = true; # AMDGPU support for packages

  hardware.bluetooth.enable = true;
  services.blueman.enable = lib.mkIf config.hardware.bluetooth.enable true;
}
