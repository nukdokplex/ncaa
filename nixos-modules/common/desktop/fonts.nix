{ pkgs, lib, config, ... }: {
  config = lib.mkIf config.common.desktop.enable {
    fonts.packages = with pkgs; [
      jetbrains-mono
      noto-fonts
      noto-fonts-lgc-plus
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      noto-fonts-extra
      nerd-fonts.symbols-only
      nerd-fonts.dejavu-sans-mono
    ];
  };
}
