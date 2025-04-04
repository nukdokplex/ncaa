{ lib, config, ... }: {
  services.openssh = {
    enable = true;
    ports = [ 33727 ];
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      AllowGroups = [ "users" "root" ];
    };
  };
}
