{ pkgs, ... }:
{
  virtualisation = {
    # Enable common container config files in /etc/containers
    containers.enable = true;
    oci-containers.backend = "podman";

    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # Useful other development tools
  environment.systemPackages = with pkgs; [
    dive # look into docker image layers
    podman-tui # status of containers in the terminal
    # docker-compose # start group of containers for dev
    podman-compose # start group of containers for dev
  ];

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
