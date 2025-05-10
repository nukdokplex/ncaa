{
  flakeRoot,
  config,
  lib,
  ...
}:
{
  age.rekey = lib.fix (rekey: {
    masterIdentities = [
      {
        pubkey = "age1hqc7vzh0gyxam67aded9eu7uzxlr2dp232zn25879xll938rpqyss94ny4";
        identity = ./master.age;
      }
    ];
    storageMode = "local";
    localStorageDir = flakeRoot + /secrets/rekeyed/${config.networking.hostName};
    secretsDir = flakeRoot + /secrets/non-generated/${config.networking.hostName};
    generatedSecretsDir = flakeRoot + /secrets/generated/${config.networking.hostName};
  });
}
