{ config, flakeRoot, ... }: {
  networking.networkmanager.ensureProfiles = {
    environmentFiles = [
      config.age.secrets.networkmanager_env.path
    ];
    profiles = {
      yggdrasils_4 = {
        connection = {
          id = "yggdrasils_4";
          type = "wifi";
        };
        ipv4 = {
          method = "auto";
          may-fail = "false";
        };
        ipv6 = {
          method = "auto";
          may-fail = "false";
          addr-gen-mode = "eui64";
          ip6-privacy = "0";
        };
        wifi = {
          band = "bg";
          mac-address = "$wifi_dev_mac";
          mode = "infrastructure";
          ssid = "yggdrasils_4";
        };
        wifi-security = {
          key-mgmt = "sae";
          psk = "$yggdrasils_wifi_psk";
        };
      };
      yggdrasils_5 = {
        connection = {
          id = "yggdrasils_5";
          type = "wifi";
        };
        ipv4 = {
          method = "auto";
          may-fail = "false";
        };
        ipv6 = {
          method = "auto";
          may-fail = "false";
          addr-gen-mode = "eui64";
          ip6-privacy = "0";
        };
        wifi = {
          band = "a";
          mac-address = "$wifi_dev_mac";
          mode = "infrastructure";
          ssid = "yggdrasils_5";
        };
        wifi-security = {
          key-mgmt = "sae";
          psk = "$yggdrasils_wifi_psk";
        };
      };
    };
  };

  age.secrets.networkmanager_env.rekeyFile = flakeRoot + /secrets/generated/${config.networking.hostName}/networkmanager_env.age;
}
