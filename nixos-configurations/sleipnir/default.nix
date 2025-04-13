{ pkgs, ezModules, inputs, ... }: {
  imports = inputs.self.lib.umport {
    path = ./modules;
    exclude = [ ./modules/sway.nix ];
  } ++ [
    ezModules.common-desktop
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.rocmSupport = true; # AMDGPU support for packages
  time.timeZone = "Asia/Yekaterinburg";
  system.stateVersion = "25.05";
  hardware.enableAllFirmware = true;

  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIImflw7aBhpCAkjmlblGq4kCzKMHdq9GPJDPUj3bW7Au root@sleipnir";

  networking.firewall.interfaces.enp42s0 = {
    allowedUDPPorts = [ 22000 ];
    allowedTCPPorts = [ 22000 ];
  };
  networking.interfaces.enp42s0.wakeOnLan.enable = true;

  programs.optical-disk-essentials.enable = true; 
  programs.k3b-custom.enable = true;

  hardware.bluetooth.enable = true;

  home-manager.sharedModules = [{
    programs.gaming-essentials.enable = true;
  }];

  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      runAsRoot = true;
      swtpm.enable = true;
      ovmf = {
        enable = true;
        packages = [
          (pkgs.OVMF.override {
            secureBoot = true;
            tpmSupport = true;
          }).fd
        ];
      };
    };
  };
}
