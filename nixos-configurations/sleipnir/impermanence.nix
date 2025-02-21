{ inputs, ... }: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  programs.fuse.userAllowOther = true;

  environment.persistence.main = {
    persistentStoragePath = "/persistent"; 
    directories = [
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/etc/ssh"
    ];
    files = [
      "/etc/machine-id"
    ];
    users.nukdokplex = {
      directories = [
        { directory = ".local/state/syncthing"; mode = "0700"; }
        ".local/state/wireplumber"
        { directory = ".local/share/AyuGramDesktop"; mode = "0700"; }
        { directory = ".mozilla"; mode = "0700"; }
        { directory = ".thunderbird"; mode = "0700"; }
        { directory = ".local/share/Steam"; }
        ".config/spotify"
        ".config/vesktop"
      ];
      files = [
        ".config/mimeapps.list"
        ".config/syncthingtray.ini"
      ];
    };
  };

  home-manager.users.nukdokplex = { inputs, ... }: {
    imports = [
      inputs.impermanence.homeManagerModules.impermanence
    ];

    home.persistence.archive = {
      allowOther = true;
      persistentStoragePath = "/data/archive/nukdokplex"; 
      directories = [
        ".ssh"
        ".gnupg"
        "ncaa"
        "desktop"
        "documents"
        "download"
        "music"
        "pictures"
        "publicShare"
        "templates"
        "videos"
        "keepass"
      ];
    };
  };
}

