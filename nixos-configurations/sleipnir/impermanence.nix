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

  home-manager.users.nukdokplex = { inputs, ... }: {
    imports = [
      inputs.impermanence.homeManagerModules.impermanence
    ];
    home.persistence."/persistent/home/nukdokplex" = {
      directories = [
        {
          directory = ".local/share/Steam";
          method = "symlink";
        }
      ];
      allowOther = true;
    };
    home.persistence."/data/archive/nukdokplex" = {
      directories = [ ".gnupg" ] ++ (
        builtins.map
          (directory: { inherit directory; method = "symlink"; })
          [ ".ssh" "desktop" "documents" "download" "music" "pictures" "publicShare" "templates" "videos" ]
      );
      allowOther = true;
    };
  };
}

