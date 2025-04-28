{ pkgs, inputs, ... }:
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
    ];
    initLua = ''
      require("custom-shell"):setup({
        history_path = "default",
        save_history = true,
      })
      require("bunny"):setup({
        hops = {
          { key = "r",          path = "/",                                    },
          { key = "v",          path = "/var",                                 },
          { key = "t",          path = "/tmp",                                 },
          { key = "n",          path = "/nix/store",     desc = "Nix store"    },
          { key = { "h", "h" }, path = "~",              desc = "Home"         },
          { key = { "h", "m" }, path = "~/Music",        desc = "Music"        },
          { key = { "h", "d" }, path = "~/Documents",    desc = "Documents"    },
          { key = { "h", "k" }, path = "~/Desktop",      desc = "Desktop"      },
          { key = "c",          path = "~/.config",      desc = "Config files" },
          { key = { "l", "s" }, path = "~/.local/share", desc = "Local share"  },
          { key = { "l", "b" }, path = "~/.local/bin",   desc = "Local bin"    },
          { key = { "l", "t" }, path = "~/.local/state", desc = "Local state"  },
          -- key and path attributes are required, desc is optional
        },
        desc_strategy = "path", -- If desc isn't present, use "path" or "filename", default is "path"
        notify = false, -- Notify after hopping, default is false
        fuzzy_cmd = "fzf", -- Fuzzy searching command, default is "fzf"
      })
    '';
  };
}
