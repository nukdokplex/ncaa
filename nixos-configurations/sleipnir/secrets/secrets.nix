let
  userKeys = import ../../../home-configurations/nukdokplex/ssh-keys.nix;
  hostKeys = import ../ssh-keys.nix;
  files = [
    "yggdrasil"
  ];
in builtins.listToAttrs (
  builtins.map
    (file: { name = file; value = { publicKeys = userKeys ++ hostKeys; }; })
    files
)
