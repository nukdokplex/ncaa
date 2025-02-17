{ inputs, ... }: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  programs.fuse.userAllowOther = true;

  environment.persistence."/persistent/system" = {
    enable = true;
    hideMounts = true;
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
  };

  environment.persistence."/persistent/home/nukdokplex".users.nukdokplex = {
    directories = [
      { directory = ".local/state/syncthing"; mode = "0700"; }
      ".local/state/wireplumber"
      { directory = ".local/share/TelegramDesktop"; mode = "0700"; }
      { directory = ".mozilla"; mode = "0700"; }
      { directory = ".thunderbird"; mode = "0700"; }
      { directory = ".local/share/Steam"; }
    ];
    files = [
      ".config/mimeapps.list"
    ];
  };

  environment.persistence."/data/archive/nukdokplex".users.nukdokplex = {
    directories = [
      { directory = ".gnupg"; mode = "0700"; }
      { directory = ".ssh"; mode = "0700"; }
      "ncaa"
      "desktop"
      "documents"
      "download"
      "music"
      "pictures"
      "publicShare"
      "templates"
      "videos"
    ];
  };
}

