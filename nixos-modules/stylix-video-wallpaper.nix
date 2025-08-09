{
  lib,
  config,
  pkgs,
  options,
  ...
}:
let
  cfg = config.stylix;
in
{
  options.stylix = {
    video = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      apply = value: if value == null || lib.isDerivation value then value else "${value}";
      description = ''
        Wallpaper video.

        If image is not set then first frame of this video will be used as wallpaper image.
      '';
    };
  };

  # thx @voronind-com
  config = lib.mkIf (cfg.video != null) (
    let
      frameDrv = pkgs.runCommand "stylix-video-frame" { } ''
        '${lib.getExe pkgs.ffmpeg}' -hide_banner -loglevel error -ss "00:00:00" -i '${cfg.video}' -vframes 1 -q:v 2 -pix_fmt rgb24 frame.png
        '${lib.getExe pkgs.optipng}' frame.png
        cp frame.png "$out"
      '';
    in
    {
      stylix.image = lib.mkDefault frameDrv;
    }
    // (lib.optionalAttrs (options ? home-manager) {
      home-manager.sharedModules = lib.optional (
        cfg.enable && cfg.homeManagerIntegration.autoImport && cfg.homeManagerIntegration.followSystem
      ) { stylix.video = cfg.video; };
    })
  );
}
