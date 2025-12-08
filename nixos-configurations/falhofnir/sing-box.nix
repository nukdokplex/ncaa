{
  services.sing-box = {
    enable = true;
    settings = {
      inbounds = [
        {
          type = "socks";
          tag = "socks-in";
          listen = "0.0.0.0";
          listen_port = 21061;
        }
      ];
    };
  };
}
