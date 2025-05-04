{ config, ... }:
{
  # https://nixos.wiki/wiki/Bootloader#Keeping_kernels.2Finitrd_on_the_main_partition
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  disko.devices = {
    disk.nvme0 = {
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
              mountpoint = config.boot.loader.efi.efiSysMountPoint;
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
    {
      name = "data-fastext.mount";
      enable = true;
      wantedBy = [ "multi-user.target" ];
      what = "/dev/disk/by-label/FASTEXT";
      where = "/data/fastext";
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
              "publicShare"
              "templates"
              "videos"
              "keepass"
            ]
        );
      }
    )
  ];
}
