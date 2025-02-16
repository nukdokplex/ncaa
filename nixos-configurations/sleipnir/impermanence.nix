{ inputs, ... }: {
  imports = [
    inputs.impermanence.nixosModules.impermanence
  ];

  environment.persistence."/persistent" = {
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

  home-manager.users.nukdokplex = { inputs, ... }: {
    imports = [
      inputs.impermanence.homeManagerModules.impermanence
    ];
    home.persistence."/persistent/home/nukdokplex" = {
      directories = [
        ".gnupg"
        ".ssh"
        "desktop"
        "documents"
        "download"
        "music"
        "pictures"
        "publicShare"
        "templates"
        "videos"
      ];
      allowOther = true;
    };
  };
}

