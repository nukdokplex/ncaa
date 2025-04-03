let
  userKeys = import ../../home-configurations/nukdokplex/ssh-keys.nix;
  hostKeys = 
    (import ../../nixos-configurations/gladr/ssh-keys.nix) ++
    (import ../../nixos-configurations/sleipnir/ssh-keys.nix);
  keys = userKeys ++ hostKeys;
in {
  # you can generate this file like that:
  # EDITOR=tee mkpasswd --stdin --method=sha-512 | agenix -e nukdokplex-password
  # also you may want to see ../my-common-base.nix
  "nukdokplex-password".publicKeys = keys;
}

