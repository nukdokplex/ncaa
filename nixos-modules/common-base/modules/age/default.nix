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
        identity = ./pico-fido-1.pub;
        pubkey = "age10crup2cf6jkhytl0xm03wns6heewn3rvxaan7jp85990mwwas3fs8392z9";
      }
      {
        identity = ./openpgp-card-1.pub;
        pubkey = "age1q87qln93vs9g9x4zkx2cc4v59duykng0xqdzjtjvs43qc6qqkujsq4kv3f";
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
