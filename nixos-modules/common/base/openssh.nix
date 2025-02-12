{ lib, config, ... }: {
  config = lib.mkIf config.common.base.enable {
    services.openssh = {
      enable = true;
      ports = [ 33727 ];
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        AllowGroups = [ "users" "root" ];
      };
    };
  };
}
