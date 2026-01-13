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
            start = "1M";
            end = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot/efi";
              mountOptions = [ "umask=0077" ];
            };
          };
          system = {
            size = "100%";
            content = {
              type = "luks";
              name = "system";
              settings = {
                allowDiscards = true;
              };
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
                        size = "24G";
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
}
