{ pkgs, config, lib, ... }:
{
  config = lib.mkIf config.common.base.enable {
    environment.systemPackages = with pkgs; [
      apfsprogs
      btrfs-progs
      cryptsetup
      dosfstools
      e2fsprogs
      exfatprogs
      f2fs-tools
      hfsprogs
      ntfs3g
      reiserfsprogs
      xfsprogs
      zfs
    ];
  };
}
