{
  flakeRoot,
  config,
  lib,
  pkgs,
  ...
}:
{
  age.rekey = lib.fix (rekey: {
    agePlugins = [ pkgs.age-plugin-fido2-hmac ];
    masterIdentities = [ ./pico-fido-1.pub ];
    extraEncryptionPubkeys = [ "age1hqc7vzh0gyxam67aded9eu7uzxlr2dp232zn25879xll938rpqyss94ny4" ];
    storageMode = "local";
    localStorageDir = flakeRoot + /secrets/rekeyed/${config.networking.hostName};
    secretsDir = flakeRoot + /secrets/non-generated/${config.networking.hostName};
    generatedSecretsDir = flakeRoot + /secrets/generated/${config.networking.hostName};
  });
}
