{
  boot.loader = {
    grub = {
      enable = true;
      efiSupport = false;
      # no need to set devices; it's taken by disko
    };
  };
}
