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
        identity = ./fido-2362853.pub;
        pubkey = "age1a2l36tx3e0mut3fz0gehqrlqp37mprv4xn08pg8sgarg26uaecmsxgq3hg";
      }
      {
        identity = ./fido-32050569.pub;
        pubkey = "age1emhhqlwqugef6sa89qllqaxd4wtmz5g5qq8r22kpx4dc3vgdtd9sc903pa";
      }
      # {
      #   identity = ./backup.age;
      #   pubkey = "age1uhv9l24d4rnrxtydm4mvmmh2653x22ae0ysmhgejhmrtsr8a6e6qnh29vf";
      # }
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
