{ lib, config, ... }:
{
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      AllowGroups = [
        "users"
        "root"
      ];
    };
  };
}
