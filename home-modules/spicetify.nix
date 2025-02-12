{ pkgs, lib, config, inputs, ... }: let
  cfg = config.programs.spicetify;
in {
  options.programs.spicetify.enableCustomConfiguration = lib.mkEnableOption "custom Spicetify configuration";
  imports = [
    inputs.spicetify.homeManagerModules.default
  ];

  config = lib.mkIf (cfg.enable && cfg.enableCustomConfiguration) {
    programs.spicetify = let
      spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
    in {
      spotifyPackage = pkgs.spotify;
      theme = spicePkgs.themes.onepunch; # pretty cool gruvbox theme

      enabledExtensions = with spicePkgs; [
        betterGenres
        showQueueDuration
        songStats
      ];

      enabledCustomApps = with spicePkgs; [
        newReleases
        reddit
      ];
    };
  };
}



  
