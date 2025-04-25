{ lib, config, pkgs, ... }: {
  programs.librewolf = {
    enable = lib.mkDefault config.home.isDesktop;
    package = pkgs.librewolf;
    settings = {
      
    };
  };

  stylix.targets.librewolf.profileNames = [ "default" ];
}
