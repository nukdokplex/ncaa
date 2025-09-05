{ config, ... }:
{
  # we can't trust wifi interface so it's empty for now
  networking.nftables.firewall.zones.trusted = { };

  networking.networkmanager.ensureProfiles = {
    environmentFiles = [
      config.age.secrets.networkmanager_env.path
    ];
    profiles = {
      asgard_4 = {
        connection = {
          id = "asgard_4";
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
          ssid = "asgard_4";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$asgard_wifi_psk";
        };
      };
      asgard_5 = {
        connection = {
          id = "asgard_5";
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
          ssid = "asgard_5";
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "$asgard_wifi_psk";
        };
      };
    };
  };

  age.secrets.networkmanager_env = { };
}
