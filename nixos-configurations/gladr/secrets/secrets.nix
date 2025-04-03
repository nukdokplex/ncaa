let
  userKeys = import ../../../home-configurations/nukdokplex/ssh-keys.nix;
  hostKeys = import ../ssh-keys.nix;
  files = [
    # secureboot
    "secureboot/GUID"
    "secureboot/keys/KEK/KEK.key"
    "secureboot/keys/KEK/KEK.pem"
    "secureboot/keys/PK/PK.key"
    "secureboot/keys/PK/PK.pem"
    "secureboot/keys/db/db.key"
    "secureboot/keys/db/db.pem"
    "nm_secrets"
  ];
in builtins.listToAttrs (
  builtins.map
    (file: { name = file; value = { publicKeys = userKeys ++ hostKeys; }; })
    files
)
