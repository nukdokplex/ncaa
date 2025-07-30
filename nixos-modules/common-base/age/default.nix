{
  flakeRoot,
  config,
  pkgs,
  ...
}:
{
  age.rekey = {
    agePlugins = [ pkgs.age-plugin-fido2-hmac ];
    masterIdentities = [
      {
        identity = ./fido2-identity-1.pub;
        pubkey = "age1shz2tstp72sk93rgtj4nwksksye9dwtmu4spt5v3a3kzg3j7r3jqawdq6d";
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
}
