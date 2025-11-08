{
  pkgs,
  lib,
  config,
  ...
}:
{
  services.greetd = {
    enable = true;
    useTextGreeter = true;
    settings = {
      default_session = {
        command = "${lib.getExe pkgs.tuigreet} --time --greeting 'Welcome to ${config.networking.hostName}!' --remember --remember-user-session --user-menu";
      };
    };
  };
}
