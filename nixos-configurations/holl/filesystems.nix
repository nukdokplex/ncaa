{ config, lib, ... }:
{
  boot = {
    loader.efi.efiSysMountPoint =
      config.disko.devices.disk.nixos.content.partitions.ESP.content.mountpoint;

    supportedFilesystems = {
      zfs = true;
    };

    zfs.extraPools = [ "data" ]; # for auto-import
  };

  disko.devices = {
    disk.nixos = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-NVME_SSD_512GB_D5BXRN35300022";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
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
            end = "-36G";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
          swap = {
            size = "100%";
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true;
            };
          };
        };
      };
    };
    nodev = {
      "/tmp" = {
        fsType = "tmpfs";
        mountOptions = [
          "size=1536M"
        ];
      };
    };
  };

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "monthly";
      randomizedDelaySec = "6h";
    };

    autoSnapshot = {
      enable = true;
      flags = "-k -p --utc";

      frequent = 4; # 15 minutes
      hourly = 12;
      daily = 3;
      weekly = 2;
      monthly = 0;
    };
  };

  home-manager.users.nukdokplex.imports = lib.singleton (
    { ... }:
    {
      # home.file =
      #   {
      #     documents = "/data/archive/nukdokplex/documents";
      #     pictures = "/data/archive/nukdokplex/pictures";
      #     templates = "/data/archive/nukdokplex/templates";
      #     videos = "/data/archive/nukdokplex/videos";
      #     music = "/data/downloads/music";
      #   }
      #   |> lib.mapAttrs (
      #     name: sourcePath: {
      #       source = config.lib.file.mkOutOfStoreSymlink sourcePath;
      #       target = name;
      #     }
      #   );
    }
  );

  services.samba = {
    enable = true;
    nmbd.enable = false;
    settings = {
      global = {
        "browseable" = "no";
        "create mask" = "0640";
        "directory mask" = "750";
        "guest account" = "nobody";
        "guest ok" = "no";
        "hosts allow" = "0.0.0.0/0";
        "read only" = "no";
        "security" = "user";
        "server string" = "SERVER";
        "smb encrypt" = "required";
        "workgroup" = "WORKGROUP";
        "writeable" = "yes";
      };
      music = {
        "path" = "/data/music";
        "guest ok" = "no";
        "valid users" = "@music";
        "create mask" = "0664";
        "directory mask" = "2775";
      };
      torrents = {
        "path" = "/data/torrents";
        "guest ok" = "no";
        "valid users" = "@torrent";
        "create mask" = "0664";
        "directory mask" = "2775";
      };
      documents = {
        "path" = "/data/documents";
        "guest ok" = "no";
        "valid users" = "@documents";
        "create mask" = "0660";
        "directory mask" = "2770";
      };
      pictures = {
        "path" = "/data/pictures";
        "guest ok" = "no";
        "valid users" = "@pictures";
        "create mask" = "0660";
        "directory mask" = "2770";
      };
    };
  };

  systemd.tmpfiles.rules = [
    # type path mode user group age argument
    "z /data/torrents 2775 root torrent - -"
    "A /data/torrents - - - - group:torrent:rwx"
    "A+ /data/torrents - - - - default:group:torrent:rwx"

    "z /data/music 2775 root music - -"
    "A /data/music - - - - group:music:rwx"
    "A+ /data/music - - - - default:group:music:rwx"

    "z /data/documents 2770 root documents - -"
    "A /data/documents - - - - group:documents:rwx"
    "A+ /data/documents - - - - default:group:documents:rwx"

    "z /data/pictures 2770 root pictures - -"
    "A /data/pictures - - - - group:pictures:rwx"
    "A+ /data/pictures - - - - default:group:pictures:rwx"
  ];

  networking.nftables.firewall.rules.open-ports-uplink = {
    allowedTCPPorts = [
      139
      445
    ];
    allowedUDPPorts = [
      137
      138
    ];
  };

}
