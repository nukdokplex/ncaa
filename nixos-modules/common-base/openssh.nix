{
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      AllowGroups = [
        "users"
        "root"
      ];
    };
  };
}
