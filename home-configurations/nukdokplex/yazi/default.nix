{ pkgs, ... }:
{
  imports = [ ./termfilechooser.nix ];
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.yazi;
    initLua = ./init.lua;

    keymap = {
      mgr.prepend_keymap = [
        {
          on = [
            "g"
            "i"
          ];
          run = "plugin lazygit";
          desc = "run lazygit";
        }
        {
          on = [
            "f"
            "r"
          ];
          run = "plugin fr rg";
          desc = "Search file by content (rg)";
        }
        {
          on = [
            "f"
            "a"
          ];
          run = "plugin fr rga";
          desc = "Search file by content (rga)";
        }
      ];
    };

    plugins = {
      fr = pkgs.stdenvNoCC.mkDerivation {
        pname = "fr-yazi-plugin";
        version = "0-unstable-2025-07-14";
        src = pkgs.fetchFromGitHub {
          owner = "lpnh";
          repo = "fr.yazi";
          rev = "3d32e55b7367334abaa91f36798ef723098d0a6b";
          hash = "sha256-CrKwFMaiEK+TNW6GRZzyt9MfOmjIb3vw0hBpBXyn16k=";
        };
        installPhase = ''
          runHook preInstall
          install -D "$src/main.lua" "$out/main.lua"
          runHook postInstall
        '';
      };
      lazygit = pkgs.stdenvNoCC.mkDerivation {
        pname = "lazygit-yazi-plugin";
        version = "0-unstable-2025-03-31";
        src = pkgs.fetchFromGitHub {
          owner = "Lil-Dank";
          repo = "lazygit.yazi";
          rev = "7a08a0988c2b7481d3f267f3bdc58080e6047e7d";
          hash = "sha256-OJJPgpSaUHYz8a9opVLCds+VZsK1B6T+pSRJyVgYNy8=";
        };
        installPhase = ''
          runHook preInstall
          install -D "$src/main.lua" "$out/main.lua"
          runHook postInstall
        '';
      };
    };
  };
}
