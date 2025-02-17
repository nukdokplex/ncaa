{ lib, ... }: {
  boot = {
    initrd = {
      enable = true;
      includeDefaultModules = true;
      network.enable = true;
      kernelModules = [ "amdgpu" ]; # because i want make correct modeset early
      postDeviceCommands = lib.mkAfter ''
        mkdir /btrfs_tmp
        mount /dev/mainpool/nixos /btrfs_tmp
        if [[ -e /btrfs_tmp/rootfs ]]; then
          mkdir -p /btrfs_tmp/old_rootfs
          timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/rootfs)" "+%Y-%m-%-d_%H:%M:%S")
          mv /btrfs_tmp/rootfs "/btrfs_tmp/old_rootfs/$timestamp"
        fi

        delete_subvolume_recursively() {
          IFS=$'\n'
          for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
          done
          btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_rootfs/ -maxdepth 1 -mtime +30); do
          delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/rootfs
        umount /btrfs_tmp
      '';
    };
    kernelModules = [ "kvm-amd" "amdgpu" ];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        efiSupport = true;
        useOSProber = true;
        device = "nodev"; # this affects only BIOS system
      };
    };
  };
}
