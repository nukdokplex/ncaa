{ pkgs, lib, ... }: {
  # you can get all plugin hashes this way:
  # nix env shell nixpkgs#nix-prefetch
  # for i in $(seq 0 6); do nix-prefetch "{ pkgs }: (builtins.elemAt (import ./ranger.nix { inherit pkgs; }).programs.ranger.plugins $i).src"; done

  home.packages = with pkgs; [
    zoxide # required by ranger-zoxide plugin
    ueberzug
    dragon-drop
  ];
  programs.ranger = {
    enable = true;
    package = pkgs.ranger;
    plugins = [
      {
        name = "devicons2";
        src = pkgs.fetchFromGitHub {
          owner = "cdump";
          repo = "ranger-devicons2";
          rev = "94bdcc19218681debb252475fd9d11cfd274d9b1";
          hash = "sha256-aJCIoDfzmOnzMLlbOe+dy6129n5Dc4OrefhHnPsgI8k=";
        };
      }
      {
        name = "archives";
        src = pkgs.fetchFromGitHub {
          owner = "maximtrp";
          repo = "ranger-archives";
          rev = "b4e136b24fdca7670e0c6105fb496e5df356ef25";
          hash = "sha256-QJu5G2AYtwcaE355yhiG4wxGFMQvmBWvaPQGLsi5x9Q=";
        };
      }
      {
        name = "udisk_menu";
        src = pkgs.fetchFromGitHub {
          owner = "SL-RU";
          repo = "ranger_udisk_menu";
          rev = "d676b7d5406d804ea4ceb894768674a740d95ebb";
          hash = "sha256-AzuWe6KXXusUfn8UABRq93/tvtiUB1OIlxGiljNuc2g=";
        };
      }
      {
        name = "lame";
        src = pkgs.fetchFromGitHub {
          owner = "madskjeldgaard";
          repo = "ranger-lame";
          rev = "49fa43dfa8ff16f34fd51b41117ecfc35df2461e";
          hash = "sha256-B5q6E1j+YXdGSKFQEKOnzp/o5DaCrIAjnYCYXzgntTc=";
        };
      }
      {
        name = "gpg";
        src = pkgs.fetchFromGitLab {
          owner = "Ragnyll";
          repo = "ranger-gpg";
          rev = "d2d97786408233b4905d8266ccd0a2516c2b891b";
          hash = "sha256-8XRNBKQplN+nuCFmIy7dNV5DeE9UY5b8tZPF4TwoqYk=";
        };
      }
      {
        name = "gitplug";
        src = pkgs.fetchFromGitHub {
          owner = "ywwa";
          repo = "ranger-gitplug";
          rev = "3819064ce2d34b3e36df0254e3b09284ee848f96";
          hash = "sha256-UeFJ+zrpu7zhJ3omKAWIKjbpiQ58S4VmAKJVsYy9VKU=";
        };
      }
      {
        name = "zoxide";
        src = pkgs.fetchFromGitHub {
          owner = "jchook";
          repo = "ranger-zoxide";
          rev = "281828de060299f73fe0b02fcabf4f2f2bd78ab3";
          hash = "sha256-JEuyYSVa1NS3aftezEJx/k19lwwzf7XhqBCL0jH6VT4=";
        };
      }
    ];
    settings = {
      default_linemode = "devicons2";
      preview_images_method = "ueberzug";
    };
    mappings = {
      Q = "quitall";
      q = "quit";
      ex = "extract_to_dirs";
      ec = "compress";
      "<C-d>" = "shell '${lib.getExe pkgs.dragon-drop}' -a -x %p";
    };
  };
}

