{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    enableZshIntegration = true;
  };
}
