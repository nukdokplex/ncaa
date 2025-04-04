{ lib, config, ... }: {
  services.yggdrasil = lib.mkIf (lib.hasAttr "yggdrasil" config.age.secrets) (lib.mkDefault {
    enable = true;
  });
}
