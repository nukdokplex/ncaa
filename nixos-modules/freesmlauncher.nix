{
  pkgs,
  inputs,
  lib,
  ...
}:
let
  freesmlauncher-wrapped = pkgs.mkBwrapper {
    app = {
      package =
        inputs.freesmlauncher.packages.${pkgs.stdenv.hostPlatform.system}.freesmlauncher.overrideAttrs
          {
            pname = "freesmlauncher";
            version = "0-unstable";
            meta = {
              description = "freesmlauncher maybe";
              homepage = "https://github.com/FreesmTeam/FreesmLauncher";
              license = lib.licenses.gpl3Only;
              mainProgram = "freesmlauncher";
            };
          };
    };
    mounts = {
      read = [
        "$XDG_DOWNLOAD_DIR"
        "$HOME/.ftba"
        "/sys/kernel/mm/hugepages"
        "/sys/kernel/mm/transparent_hugepage"
        "/run/systemd/resolve/stub-resolv.conf" # https://github.com/Naxdy/nix-bwrapper/issues/23
      ];
      readWrite = [
        "$XDG_RUNTIME_DIR/app/com.discordapp.Discord"
      ];
    };
  };
in
{
  environment.systemPackages = [
    freesmlauncher-wrapped
  ];
}
