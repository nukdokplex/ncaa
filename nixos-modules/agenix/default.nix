{
  flakeRoot,
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    inputs.agenix.nixosModules.default
    inputs.agenix-rekey.nixosModules.default
    ./generators.nix
  ];
  age.rekey = {
    agePlugins = [ pkgs.age-plugin-fido2-hmac ];
    masterIdentities = [
      {
        # 0643DA9F
        identity = ./fido2-0643DA9F.pub;
        pubkey = "age1shz2tstp72sk93rgtj4nwksksye9dwtmu4spt5v3a3kzg3j7r3jqawdq6d";
      }
      {
        # 775BC6BC
        identity = ./fido2-775BC6BC.pub;
        pubkey = "age14eg3wdumvpwmsgdk3ctdkvtw43am8kq43wq4hzejzt9fqrpgggqsyzutrm";
      }
    ];
    extraEncryptionPubkeys = [
      "age1uhv9l24d4rnrxtydm4mvmmh2653x22ae0ysmhgejhmrtsr8a6e6qnh29vf"
    ];
    storageMode = "local";
    localStorageDir = flakeRoot + /secrets/rekeyed/${config.networking.hostName};
    secretsDir = flakeRoot + /secrets/non-generated/${config.networking.hostName};
    generatedSecretsDir = flakeRoot + /secrets/generated/${config.networking.hostName};
  };

  environment.systemPackages = with pkgs; [
    rage
    age-plugin-fido2-hmac
    age-plugin-openpgp-card
    age-plugin-yubikey
  ];
}
