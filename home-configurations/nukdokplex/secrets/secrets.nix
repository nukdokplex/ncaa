let
  ssh-keys = import ../ssh-keys.nix;
  files = [
    "factorio-token"
  ];
in builtins.listToAttrs (
  builtins.map
    (file: { name = file; value = { publicKeys = ssh-keys; }; })
    files
)
