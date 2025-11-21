{ config, lib, ... }:
{
  boot.loader.efi.efiSysMountPoint =
    config.disko.devices.disk.nixos.content.partitions.ESP.content.mountpoint;

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
          "size=200M"
        ];
      };
    };
  };

  systemd.mounts = [
    {
      name = "data-archive.mount";
      enable = true;
      wantedBy = [ "multi-user.target" ];
      what = "/dev/disk/by-label/ARCHIVE";
      where = "/data/archive";
      type = "ext4";
      options = "rw,nosuid,nodev,relatime,errors=remount-ro,x-mount.mkdir=0755";
    }
    {
      name = "data-downloads.mount";
      enable = true;
      wantedBy = [ "multi-user.target" ];
      what = "/dev/disk/by-label/DOWNLOADS";
      where = "/data/downloads";
      type = "ext4";
      options = "rw,nosuid,nodev,relatime,errors=remount-ro,x-mount.mkdir=0755";
    }
  ];
  home-manager.users.nukdokplex.imports = lib.singleton (
    { config, lib, ... }:
    {
      home.file =
        {
          documents = "/data/archive/nukdokplex/documents";
          pictures = "/data/archive/nukdokplex/pictures";
          templates = "/data/archive/nukdokplex/templates";
          videos = "/data/archive/nukdokplex/videos";
          music = "/data/downloads/music";
        }
        |> lib.mapAttrs (
          name: sourcePath: {
            source = config.lib.file.mkOutOfStoreSymlink sourcePath;
            target = name;
          }
        );
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
        "path" = "/data/downloads/music";
        "guest ok" = "no";
        "valid users" = "@music";
        "create mask" = "0664";
        "directory mask" = "2775";
      };
      torrents = {
        "path" = "/data/downloads/torrents";
        "guest ok" = "no";
        "valid users" = "@torrent";
        "create mask" = "0664";
        "directory mask" = "2775";
      };
      nukdokplex_archive = {
        "path" = "/data/archive/nukdokplex";
        "guest ok" = "no";
        "valid users" = "@nukdokplex";
        "create mask" = "0640";
        "directory mask" = "0750";
      };
    };
  };

  systemd.tmpfiles.rules = [
    # type path mode user group age argument
    "d /data/downloads/torrents 2775 qbittorrent torrent - -"
    "A /data/downloads/torrents - - - - group:torrent:rwx"
    "A+ /data/downloads/torrents - - - - default:group:torrent:rwx"

    "d /data/downloads/music 2775 navidrome music - -"
    "A /data/downloads/music - - - - group:music:rwx"
    "A+ /data/downloads/music - - - - default:group:music:rwx"
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
