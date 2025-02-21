{ pkgs, lib, config, inputs, ... }: let
  cfg = config.programs.spicetify;
in {
  options.programs.spicetify.enableCustomConfiguration = lib.mkEnableOption "custom Spicetify configuration";
  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    programs.spicetify = let
      spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      spotifyPackage = pkgs.spotify;
      windowManagerPatch = true;
      spotifyLaunchFlags = "--ozone-platform=x11"; # wm patch works only when spotify runs in x11 mode

      enabledExtensions = with spicePkgs.extensions; [
        betterGenres
        showQueueDuration
        songStats
      ];

      enabledCustomApps = with spicePkgs.apps; [
        newReleases
        reddit
      ];
    };
  };
}



  
