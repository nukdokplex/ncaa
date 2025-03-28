{ pkgs, lib, config, ... }: {
  config = lib.mkIf config.common.desktop.enable {
    services.udisks2.enable = true;
    services.gvfs.enable = true;
    environment.systemPackages = with pkgs; [
      glib # provides gio
    ];
  };
}
