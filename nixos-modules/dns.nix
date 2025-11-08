{
  services.resolved = {
    enable = true;

    fallbackDns = [
      "8.8.8.8:53"
      "[2001:4860:4860::8888]:53"
      "8.8.4.4:53"
      "[2001:4860:4860::8844]:53"
    ];

    extraConfig = ''
      Cache=no
      CacheFromLocalhost=no
    '';
  };

}
