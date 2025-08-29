{
  inputs,
  ...
}:
{
  imports = [ inputs.nixos-nftables-firewall.nixosModules.default ];

  services.resolved = {
    enable = true;

    fallbackDns = [
      "8.8.8.8:53"
      "[2001:4860:4860::8888]:53"
      "8.8.4.4:53"
      "[2001:4860:4860::8844]:53"
    ];

    extraConfig = ''
      Cache=no
      CacheFromLocalhost=no
    '';
  };

  networking.nftables.firewall = {
    enable = true;
    snippets = {
      nnf-common.enable = false;
      nnf-conntrack.enable = true;
      nnf-default-stopRuleset.enable = true;
      nnf-dhcpv6.enable = true;
      nnf-drop.enable = true;
      nnf-icmp = {
        enable = true;
        ipv4Types = [
          "echo-reply"
          "echo-request"
        ];
        ipv6Types = [
          "nd-router-solicit"
          "nd-router-advert"
          "nd-neighbor-solicit"
          "nd-neighbor-advert"
          "echo-request"
          "echo-reply"
        ];
      };
      nnf-loopback.enable = true;
      nnf-nixos-firewall.enable = true;
      nnf-ssh.enable = true;
    };
    zones = {
      uplink = {
        interfaces = [
          "uplink"
          "uplink*"
        ];
      };
    };
  };
}
