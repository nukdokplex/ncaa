{ pkgs, lib, config, ... }: {
  config = lib.mkIf config.common.base.enable {
    environment.systemPackages = with pkgs; [
      gnutar
      gzip
      p7zip
      rar
      unrar
      unzip
      zip
      zstd
    ];
  };
}
