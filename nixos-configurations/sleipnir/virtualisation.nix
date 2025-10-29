{ pkgs, ... }:
{
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  environment.systemPackages = with pkgs; [
    podman-compose
    podman-tui
    dive
  ];

  programs.virt-manager.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      runAsRoot = true;
      swtpm.enable = true;
    };
  };

  networking.nftables.chains.input.allow-podman-dns = {
    after = [ "conntrack" ];
    before = [ "late" ];
    rules = [
      { text = ''iifname "podman*" udp dport 53 accept''; }
      { text = ''iifname "podman*" tcp dport 53 accept''; }
    ];
  };

  networking.nftables.chains.forward.allow-podman-traffic = {
    after = [ "conntrack" ];
    before = [ "late" ];

    rules = [
      { text = ''iifname "podman*" oifname "uplink*" accept''; }
    ];
  };

  networking.nftables.chains.postrouting.podman-traffic-masquerade = {
    after = [ "early" ];
    before = [ "late" ];
    rules = [
      { text = ''iifname "podman*" oifname "uplink*" masquerade''; }
    ];
  };
}
