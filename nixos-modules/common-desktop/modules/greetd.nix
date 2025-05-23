{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.greetd = {
    enable = true;
    vt = 2;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.greetd.tuigreet} --time --greeting 'Welcome to ${config.networking.hostName}!' --remember --remember-user-session --user-menu";
      };
    };
  };
}
