let
  userKeys = import ../../../home-configurations/nukdokplex/ssh-keys.nix;
  hostKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPtJzMUNnPdGEWwpwO2lhHnTJxCfKS7X4hpuakqa1hrq root@ams-out.nukdokplex.ru"
  ];
  files = [
    "wan_address"
  ];
in builtins.listToAttrs (
  builtins.map
    (file: { name = file; value = { publicKeys = userKeys ++ hostKeys; }; })
    files
)
