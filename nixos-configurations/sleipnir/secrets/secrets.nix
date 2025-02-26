let
  userKeys = import ../../../home-configurations/nukdokplex/ssh-keys.nix;
  hostKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIImflw7aBhpCAkjmlblGq4kCzKMHdq9GPJDPUj3bW7Au root@sleipnir"
  ];
  files = [
    "yggdrasil"
  ];
in builtins.listToAttrs (
  builtins.map
    (file: { name = file; value = { publicKeys = userKeys ++ hostKeys; }; })
    files
)
