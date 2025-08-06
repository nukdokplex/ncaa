{
  disko.devices = {
    disk.main = {
      device = "/dev/vda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          MBR = {
            size = "1M";
            type = "EF02"; # for grub MBR
          };
          root = {
            size = "100%";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
            };
          };
          swap = {
            size = "1G";
            content = {
              type = "swap";
            };
          };
        };
      };
    };
  };
}
