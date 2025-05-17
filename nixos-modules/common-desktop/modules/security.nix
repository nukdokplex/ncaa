{ pkgs, ... }:
{
  security.polkit.enable = true;

  services.pcscd = {
    enable = true;
    plugins = with pkgs; [
      ccid
    ];
  };
}
