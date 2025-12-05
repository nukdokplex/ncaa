{
  config,
  inputs,
  pkgs,
  ...
}:
{
  boot.loader.efi.efiSysMountPoint =
    config.disko.devices.disk.nixos.content.partitions.ESP.content.mountpoint;

  boot.supportedFilesystems.cifs = true;

  environment.systemPackages = with pkgs; [
    cifs-utils
  ];

  disko.devices = {
    disk.nixos = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_500GB_S4EVNZFN703254E";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            start = "1M";
            end = "128M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              # https://nixos.wiki/wiki/Bootloader#Keeping_kernels.2Finitrd_on_the_main_partition
              mountpoint = "/boot/efi";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/rootfs" = {
                  mountpoint = "/";
                };
                "/nix" = {
                  mountOptions = [
                    "compress=zstd:3"
                    "noatime"
                  ];
                  mountpoint = "/nix";
                };
                "/home" = {
                  mountOptions = [ "compress=zstd:3" ];
                  mountpoint = "/home";
                };
                "/home/nukdokplex/" = { };
                "/swap" = {
                  mountpoint = "/.swapvolume";
                  swap = {
                    swapfile = {
                      size = "36G";
                      priority = 100;
                    };
                  };
                };
              };
            };
          };
        };
      };
    };
    disk.fastext = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-XPG_GAMMIX_S11_Pro_2N12291H7SGC";
      content = {
        type = "gpt";
        partitions = {
          fastext = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" ];
              subvolumes = {
                "/games" = {
                  mountpoint = "/data/games";
                  mountOptions = [ "noatime" ];
                };
                "/vms" = {
                  mountpoint = "/data/vms";
                  mountOptions = [ "noatime" ];
                };
              };
            };
          };
        };
      };
    };
    nodev = {
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=1G"
        ];
      };
    };
  };

  services.snapper = {
    cleanupInterval = "1d";
    persistentTimer = true;
    filters = ''
      /home/nukdokplex/.snapshots
    '';
    configs = {
      home-nukdokplex = {
        FSTYPE = "btrfs";
        SUBVOLUME = "/home/nukdokplex";
        ALLOW_USERS = [ "nukdokplex" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_YEARLY = 0;
        TIMELINE_LIMIT_QUARTERLY = 4;
        TIMELINE_LIMIT_MONTHLY = 3;
        TIMELINE_LIMIT_DAILY = 12;
        TIMELINE_LIMIT_HOURLY = 0;
      };
    };
  };

  systemd.tmpfiles.rules = [
    "v /home/nukdokplex/.snapshots 0770 root root"
  ];

  services.btrfs.autoScrub = {
    enable = true;
    interval = "weekly";
    # limit = "250M";
  };

  systemd.mounts = [
    {
      name = "home-nukdokplex-music.mount";
      wantedBy = [ "default.target" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      what = "//10.14.88.6/music";
      where = "/home/nukdokplex/music";
      type = "cifs";
      options = "rw,credentials=${config.age.secrets.music-smb-credentials.path},forceuid,forcegid,uid=${toString config.users.users.nukdokplex.uid},gid=${toString config.users.groups.nukdokplex.gid},file_mode=0660,dir_mode=0770,nobrl,x-systemd.automount,x-systemd.device-timeout=10s,x-systemd.idle-timeout=600,_netdev";
    }
    {
      name = "home-nukdokplex-torrents.mount";
      wantedBy = [ "default.target" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      what = "//10.14.88.6/torrents";
      where = "/home/nukdokplex/torrents";
      type = "cifs";
      options = "rw,credentials=${config.age.secrets.torrent-smb-credentials.path},forceuid,forcegid,uid=${toString config.users.users.nukdokplex.uid},gid=${toString config.users.groups.nukdokplex.gid},file_mode=0660,dir_mode=0770,nobrl,x-systemd.automount,x-systemd.device-timeout=10s,x-systemd.idle-timeout=600,_netdev";
    }
    {
      name = "home-nukdokplex-archive.mount";
      wantedBy = [ "default.target" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      what = "//10.14.88.6/nukdokplex_archive";
      where = "/home/nukdokplex/archive";
      type = "cifs";
      options = "rw,credentials=${config.age.secrets.nukdokplex-smb-credentials.path},forceuid,forcegid,uid=${toString config.users.users.nukdokplex.uid},gid=${toString config.users.groups.nukdokplex.gid},file_mode=0660,dir_mode=0770,nobrl,x-systemd.automount,x-systemd.device-timeout=10s,x-systemd.idle-timeout=600,_netdev";
    }
    {
      name = "home-nukdokplex-documents.mount";
      wantedBy = [ "default.target" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      what = "//10.14.88.6/nukdokplex_archive/documents";
      where = "/home/nukdokplex/documents";
      type = "cifs";
      options = "rw,credentials=${config.age.secrets.nukdokplex-smb-credentials.path},forceuid,forcegid,uid=${toString config.users.users.nukdokplex.uid},gid=${toString config.users.groups.nukdokplex.gid},file_mode=0660,dir_mode=0770,nobrl,x-systemd.automount,x-systemd.device-timeout=10s,x-systemd.idle-timeout=600,_netdev";
    }
    {
      name = "home-nukdokplex-pictures.mount";
      wantedBy = [ "default.target" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      what = "//10.14.88.6/nukdokplex_archive/pictures";
      where = "/home/nukdokplex/pictures";
      type = "cifs";
      options = "rw,credentials=${config.age.secrets.nukdokplex-smb-credentials.path},forceuid,forcegid,uid=${toString config.users.users.nukdokplex.uid},gid=${toString config.users.groups.nukdokplex.gid},file_mode=0660,dir_mode=0770,nobrl,x-systemd.automount,x-systemd.device-timeout=10s,x-systemd.idle-timeout=600,_netdev";
    }
    {
      name = "home-nukdokplex-videos.mount";
      wantedBy = [ "default.target" ];
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      what = "//10.14.88.6/nukdokplex_archive/videos";
      where = "/home/nukdokplex/videos";
      type = "cifs";
      options = "rw,credentials=${config.age.secrets.nukdokplex-smb-credentials.path},forceuid,forcegid,uid=${toString config.users.users.nukdokplex.uid},gid=${toString config.users.groups.nukdokplex.gid},file_mode=0660,dir_mode=0770,nobrl,x-systemd.automount,x-systemd.device-timeout=10s,x-systemd.idle-timeout=600,_netdev";
    }
  ];

  age.secrets = {
    music-smb-credentials.generator = {
      dependencies.password = inputs.self.nixosConfigurations.holl.config.age.secrets.music-user-password;
      script =
        { deps, decrypt, ... }:
        ''
          cat << EOF
          username=music
          password=$(${decrypt} ${deps.password.file})
          EOF
        '';
    };
    torrent-smb-credentials.generator = {
      dependencies.password =
        inputs.self.nixosConfigurations.holl.config.age.secrets.torrent-user-password;
      script =
        { deps, decrypt, ... }:
        ''
          cat << EOF
          username=torrent
          password=$(${decrypt} ${deps.password.file})
          EOF
        '';
    };
    nukdokplex-smb-credentials.generator = {
      dependencies.password =
        inputs.self.nixosConfigurations.holl.config.age.secrets.nukdokplex-smb-user-password;
      script =
        { deps, decrypt, ... }:
        ''
          cat << EOF
          username=nukdokplex
          password=$(${decrypt} ${deps.password.file})
          EOF
        '';
    };
  };
}
