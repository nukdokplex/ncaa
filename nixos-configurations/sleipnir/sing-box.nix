{ ezModules, ... }:
{
  imports = with ezModules; [
    sing-box-client
    sing-box-falhofnir-hysteria2-client
    sing-box-wrap-apps
  ];

  services.sing-box = {
    proxy-selector = {
      outbounds = [ "falhofnir-hysteria2" ];
      default = "falhofnir-hysteria2";
    };
    falhofnir-hysteria2-extraConfig = {
      up_mbps = 200;
      down_mbps = 200;
    };
  };
}
