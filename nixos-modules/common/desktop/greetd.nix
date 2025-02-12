{ pkgs, lib, config, ... }: {
  config = lib.mkIf config.common.desktop.enable {
    services.greetd = {
      enable = true;
      vt = 1;
      settings = {
        default_session = {
          command = "${lib.getExe pkgs.greetd.tuigreet} --time --greeting 'Welcome to ${config.networking.hostName}!' --remember --remember-user-session --user-menu";
        };
      };
    };
  };
}
