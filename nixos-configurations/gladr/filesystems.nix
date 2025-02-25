{
  services.fstrim.enable = true;
  disko.devices = {
    disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-HFM512GDJTNG-8310A_FY03N076611104A0B";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            priority = 0;
            end = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          system = {
            priority = 1;
            end = "-0";
            content = {
              type = "luks";
              extraOpenArgs = [];
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "lvm_pv";
                vg = "systempool";
              };
            };
          };
        };
      };
    };
    lvm_vg.systempool = {
      type = "lvm_vg";
      lvs.root = {
        size = "100%";
        priority = 0;
        content = {
          type = "filesystem";
          format = "ext4";
          mountpoint = "/";
          mountOptions = [
            "defaults"
          ];
        };
      };
      lvs.swap = {
        size = "12G";
        priority = 1;
        content = {
          type = "swap";
          resumeDevice = "true";
        };
      };
    };
  };
}
