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
  home-manager.users.nukdokplex.imports = [
    (
      { config, lib, ... }:
      {
        home.file = builtins.listToAttrs (
          builtins.map
            (
              name:
              lib.nameValuePair name {
                target = name;
                source = config.lib.file.mkOutOfStoreSymlink "/data/archive/nukdokplex/${name}";
              }
            )
            [
              "documents"
              "music"
              "pictures"
              "templates"
              "videos"
            ]
        );
      }
    )
  ];

  services.nfs.server = {
    enable = true;
    nproc = 8;
    exports = ''
      /data/archive/nukdokplex 100.100.1.0/8(rw,subtree_check)
      /data/downloads/torrents 100.100.1.0/8(rw,subtree_check)
    '';
  };

  networking.nftables.firewall.rules.open-ports-trusted.allowedTCPPorts =
    lib.optional config.services.nfs.server.enable 2049;
}
