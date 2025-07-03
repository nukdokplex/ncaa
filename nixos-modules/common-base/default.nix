{
  inputs,
  lib',
  ...
}:
{
  imports =
    [ ]
    ++ lib'.umport {
      path = ./.;
      exclude = [ ./default.nix ];
      recursive = false;
    };
}
