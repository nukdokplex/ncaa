{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.home.isDesktop {
    programs.nixcord = {
      enable = true;
      discord.enable = false;
      dorion.enable = false;
      vesktop.enable = true;

      config = {
        transparent = true;
        plugins = {
          alwaysTrust.enable = true;
          betterFolders.enable = true;
          betterGifPicker.enable = true;
          betterRoleContext.enable = true;
          betterSessions.enable = true;
          betterSettings.enable = true;
          betterUploadButton.enable = true;
          biggerStreamPreview.enable = true;
          blurNSFW.enable = true;
          callTimer.enable = true;
          clearURLs.enable = true;
          copyFileContents.enable = true;
          copyUserURLs.enable = true;
          ctrlEnterSend.enable = true;
          experiments.enable = true;
          fakeNitro.enable = true;
          iLoveSpam.enable = true;
          imageZoom.enable = true;
          implicitRelationships.enable = true;
          memberCount.enable = true;
          openInApp.enable = true;
          serverInfo.enable = true;
          spotifyCrack = {
            enable = true;
            noSpotifyAutoPause = true;
            keepSpotifyActivityOnIdle = true;
          };
        };
      };
    };
  };
}
