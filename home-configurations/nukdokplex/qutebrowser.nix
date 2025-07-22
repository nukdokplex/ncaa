{
  lib,
  config,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.home.isDesktop {
    programs.qutebrowser = {
      enable = true;
      package = pkgs.qutebrowser.override { };

      searchEngines = {
        w = "https://en.wikipedia.org/wiki/Special:Search?search={}&go=Go&ns0=1";
        aw = "https://wiki.archlinux.org/?search={}";
        nw = "https://wiki.nixos.org/index.php?search={}";
        nsp = "https://search.nixos.org/packges?channel=unstable&sort=relevance&query={}";
        nso = "https://search.nixos.org/options?channel=unstable&sort=relevance&query={}";
        hms = "https://home-manager-options.extranix.com/?release=master&query={}";
        g = "https://www.google.com/search?&q={}";
        ddg = "https://duckduckgo.com/?kp=-1&kp=-2&kz=-1&kl=ru-ru&q={}";
      };
      greasemonkey = map (x: pkgs.fetchurl x) [
        {
          url = "https://github.com/afreakk/greasemonkeyscripts/raw/69df2b309eae2af18bb1d1ff1790f1d92d8e6a5d/youtube_sponsorblock.js";
          sha256 = "1ccqg60m4if1gdhq92v50sfpwz81l2a3r55iwjqgy738xmsml0wz";
        }
        {
          url = "https://github.com/afreakk/greasemonkeyscripts/raw/69df2b309eae2af18bb1d1ff1790f1d92d8e6a5d/youtube_shorts_block.js";
          sha256 = "09lfbqphdv78l44z1b2ryba46pz4srpyswpapmi86cl41d485nkv";
        }
        {
          url = "https://github.com/afreakk/greasemonkeyscripts/raw/69df2b309eae2af18bb1d1ff1790f1d92d8e6a5d/youtube_adblock.js";
          sha256 = "1mskjnprva2zcwkmdz0m8by7zj840i9c1i30mbgs6v69h9bgs803";
        }
      ];
      enableDefaultBindings = true;
      keyMappings = { };
    };
  };
}
