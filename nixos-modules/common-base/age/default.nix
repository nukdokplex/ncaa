{
  flakeRoot,
  config,
  lib,
  pkgs,
  ...
}:
{
  age.rekey = lib.fix (rekey: {
    agePlugins = [
      pkgs.age-plugin-fido2-hmac
      pkgs.age-plugin-openpgp-card
    ];
    masterIdentities = [
      {
        identity = ./fido2-identity.pub;
        pubkey = "age1xgn3qvls0p7gp5hwkk65zzfak8wfluy3r8z466j0tvg3d9ssyaasp05k8q";
      }
    ];
    extraEncryptionPubkeys = [
      "age1uhv9l24d4rnrxtydm4mvmmh2653x22ae0ysmhgejhmrtsr8a6e6qnh29vf"
    ];
    storageMode = "local";
    localStorageDir = flakeRoot + /secrets/rekeyed/${config.networking.hostName};
    secretsDir = flakeRoot + /secrets/non-generated/${config.networking.hostName};
    generatedSecretsDir = flakeRoot + /secrets/generated/${config.networking.hostName};
  });
}
