{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-Samsung_SSD_970_EVO_Plus_500GB_S4EVNZFN703254E";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            end = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            name = "root";
            end = "-36G";
            content = {
              type = "filesystem";
              format = "f2fs";
              mountpoint = "/";
              extraArgs = [
                "-O"
                "extra_attr,inode_checksum,sb_checksum,compression"
              ];
              mountOptions = [
                "compress_algorithm=zstd:6,compress_chksum,atgc,gc_merge,lazytime,nodiscard"
              ];
            };
          };
          swap = {
            end = "-0";
            content = {
              type = "swap";
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
    ({ config, lib, ... }: {
      home.file = builtins.listToAttrs (
        builtins.map
          (name: lib.nameValuePair name { target = name; source = config.lib.file.mkOutOfStoreSymlink "/data/archive/nukdokplex/${name}"; })
          [ "desktop" "documents" "download" "music" "pictures" "publicShare" "templates" "videos" ]
      );
    })
  ];
}
