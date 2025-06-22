{
  pkgs,
  lib,
  inputs,
  config,
  ...
}:
{
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
    plugins = {
      bunny = toString inputs.bunny-yazi;
      custom-shell = toString inputs.custom-shell-yazi;
    };
    keymap.manager.prepend_keymap = [
      {
        on = [
          "b"
          "b"
        ];
        run = "plugin bunny";
        desc = "Start bunny.yazi";
      }
      {
        on = [ ";" ];
        run = "plugin custom-shell -- auto --interactive";
      }
      {
        on = [ ":" ];
        run = "plugin custom-shell -- auto --interactive --block";
      }
      {
        on = [ "<C-d>" ];
        run = "plugin custon-shelll -- custom auto '${lib.getExe pkgs.dragon-drop}'";
      }
    ];
    initLua = ''
      require("custom-shell"):setup({
        history_path = "default",
        save_history = true,
      })
      require("bunny"):setup({
        hops = {
          { key = "r", path = "/", desc = "root" },
          { key = "v", path = "/var" },
          { key = "t", path = "/tmp" },
          { key = "n", path = "/nix/store", desc = "Nix store" },
          { key = { "h", "h" }, path = "${config.home.homeDirectory}", desc = "Home" },
          { key = { "h", "m" }, path = "${config.xdg.userDirs.music}", desc = "Music" },
          { key = { "h", "d" }, path = "${config.xdg.userDirs.documents}", desc = "Documents" },
          { key = { "h", "p" }, path = "${config.xdg.userDirs.pictures}", desc = "Pictures" },
          { key = { "h", "c" }, path = "${config.xdg.configHome}", desc = "Config files" },
          { key = { "l", "s" }, path = "${config.xdg.dataHome}", desc = "Local share" },
          { key = { "l", "t" }, path = "${config.xdg.stateHome}", desc = "Local state" },
          -- key and path attributes are required, desc is optional
        },
        desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
        notify = false, -- Notify after hopping, default is false
        fuzzy_cmd = "fzf", -- Fuzzy searching command, default is "fzf"
      })
    '';
  };
}
