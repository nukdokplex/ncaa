{ config, ... }:
{
  boot.loader.efi.efiSysMountPoint =
    config.disko.devices.disk.nixos.content.partitions.ESP.content.mountpoint;

  disko.devices = {
    disk.nixos = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_500GB_S4EVNZFN703254E";
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
      name = "data-fastext.mount";
      enable = true;
      wantedBy = [ "multi-user.target" ];
      what = "/dev/disk/by-label/FASTEXT";
      where = "/data/fastext";
      type = "ext4";
      options = "rw,nosuid,nodev,relatime,errors=remount-ro,x-mount.mkdir=0755";
    }
    {
      name = "home-nukdokplex-documents.mount";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
        "netbird-nukdokplex.service"
      ];
      requires = [
        "network-online.target"
        "netbird-nukdokplex.service"
      ];
      what = "100.100.1.6:/data/archive/nukdokplex/documents";
      where = "/home/nukdokplex/documents";
      type = "nfs";
      options = "rw,noatime";
    }
    {
      name = "home-nukdokplex-pictures.mount";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
        "netbird-nukdokplex.service"
      ];
      requires = [
        "network-online.target"
        "netbird-nukdokplex.service"
      ];
      what = "100.100.1.6:/data/archive/nukdokplex/pictures";
      where = "/home/nukdokplex/pictures";
      type = "nfs";
      options = "rw,noatime";
    }
    {
      name = "home-nukdokplex-music.mount";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
        "netbird-nukdokplex.service"
      ];
      requires = [
        "network-online.target"
        "netbird-nukdokplex.service"
      ];
      what = "100.100.1.6:/data/archive/nukdokplex/music";
      where = "/home/nukdokplex/music";
      type = "nfs";
      options = "rw,noatime";
    }
    {
      name = "home-nukdokplex-videos.mount";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
        "netbird-nukdokplex.service"
      ];
      requires = [
        "network-online.target"
        "netbird-nukdokplex.service"
      ];
      what = "100.100.1.6:/data/archive/nukdokplex/videos";
      where = "/home/nukdokplex/videos";
      type = "nfs";
      options = "rw,noatime";
    }
    {
      name = "home-nukdokplex-torrents.mount";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network-online.target"
        "netbird-nukdokplex.service"
      ];
      requires = [
        "network-online.target"
        "netbird-nukdokplex.service"
      ];
      what = "100.100.1.6:/data/downloads/torrents";
      where = "/home/nukdokplex/torrents";
      type = "nfs";
      options = "rw,noatime";
    }
  ];

  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;
}
