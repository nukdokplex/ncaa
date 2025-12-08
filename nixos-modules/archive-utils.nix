{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    gnutar
    gzip
    p7zip
    # rar
    # unrar
    unzip
    zip
    zstd
  ];
}
