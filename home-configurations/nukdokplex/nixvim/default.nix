{
  lib',
  lib,
  config,
  ...
}:
{
  imports = (
    lib'.umport {
      path = ./.;
      recursive = false;
      exclude = [ ./default.nix ];
    }
  );

  programs.nixvim.enable = lib.mkIf config.home.isDesktop true;
  programs.nixvim.nixpkgs.useGlobalPackages = true;
}
