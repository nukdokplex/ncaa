{
  lib,
  config,
  ...
}:
let
  userDirs = [
    "desktop"
    "documents"
    "download"
    "music"
    "pictures"
    "publicShare"
    "templates"
    "videos"
  ];
in
{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  }
  // builtins.listToAttrs (
    builtins.map (name: lib.nameValuePair name "${config.home.homeDirectory}/${name}") userDirs
  );
}
