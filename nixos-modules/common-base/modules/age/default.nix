{ flakeRoot, config, ... }: {
  age.rekey = {
    masterIdentities = [{
      identity = ./master_identity.pub;
    }];
    storageMode = "local";
    localStorageDir = flakeRoot + "/secrets/rekeyed/${config.networking.hostName}";
  };
}
