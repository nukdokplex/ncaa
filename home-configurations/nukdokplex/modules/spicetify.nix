{ pkgs, lib, config, inputs, ... }: {
  programs.spicetify = let
    spicePkgs = inputs.spicetify.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    enable = lib.mkDefault config.home.isDesktop;
    spotifyPackage = pkgs.spotify;
    windowManagerPatch = true;
 
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
}



  
