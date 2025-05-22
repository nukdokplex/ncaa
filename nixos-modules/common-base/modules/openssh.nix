{ lib, config, ... }:
{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      AllowGroups = [
        "users"
        "root"
      ];
    };
  };

  networking.nftables.tables.filter.content = ''
    chain post_input_hook {
      tcp dport 22 counter accept comment "OpenSSH open port"
    }
  '';
}
