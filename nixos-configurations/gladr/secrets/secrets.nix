let
  userKeys = import ../../../home-configurations/nukdokplex/ssh-keys.nix;
  hostKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDo2pi5x42hS1jbB9gHvMfr3iiDWr4Mpe5CPNhpddIGH root@gladr"
  ];
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
